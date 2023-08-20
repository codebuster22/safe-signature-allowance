import { AddressZero } from "@ethersproject/constants";
import { arrayify, parseEther, solidityKeccak256 } from "ethers/lib/utils";
import { Address } from "hardhat-deploy/types";
import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { CONTRACT_NAMES } from "../config/constants";
import { GM, SignatureAllowance } from "../typechain-types";
import { checkForUndefined } from "@chain-labs/utils";

interface CreateNewSignatureUserInputs {
  amount: number;
  token: Address;
  receiver: Address;
  salt: number;
}

async function createNewSignature(
  { amount, token, receiver, salt }: CreateNewSignatureUserInputs,
  hre: HardhatRuntimeEnvironment
) {
  const { ethers, network } = hre;
  const adjustedAmount = parseEther(amount.toString());

  const [deployer] = await ethers.getSigners();

  // get token
  const gmInstance = (await ethers.getContract(CONTRACT_NAMES.GM)) as GM;

  // get signature allowance instance
  const signatureAllowanceInstance = (await ethers.getContract(
    CONTRACT_NAMES.SIGNATURE_ALLOWANCE
  )) as SignatureAllowance;

  const safeAddress = await signatureAllowanceInstance.getSafe();

  const safeInstance = await ethers.getContractAt(
    CONTRACT_NAMES.SAFE,
    safeAddress
  );

  // generate transaction data to withdraw
  const targetTrxData = await gmInstance.populateTransaction.transfer(
    receiver,
    adjustedAmount
  );

  checkForUndefined("Transaction.data", targetTrxData.data);
  const creationTime = Math.floor(Date.now() / 1000);
  const currentNonce = await safeInstance.nonce();
  const trxHash = solidityKeccak256(
    ["bytes"],
    [
      await signatureAllowanceInstance.encodeTransactionData(
        gmInstance.address,
        0,
        targetTrxData.data,
        0,
        creationTime,
        salt
      ),
    ]
  );
  const signature = (await deployer.signMessage(arrayify(trxHash)))
    .replace(/1b$/, "1f")
    .replace(/1c$/, "20");
  // return the signature and data
  console.log({
    signature: signature,
    amount: adjustedAmount,
    creationTime: creationTime,
    tokenAddress: token,
    withdrawer: receiver,
    salt: salt,
  });
}

task("createNewSignature", "Create new signature for an allowance")
  .addParam(
    "amount",
    "Amount of tokens that can be withdrawn in 10^18 denomination"
  )
  .addParam("token", "token address that needs to be withdrawn")
  .addParam("receiver", "receiver address")
  .addParam("salt", "random unique number to add randomnness")
  .setAction(createNewSignature);
