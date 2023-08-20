import { AddressZero } from '@ethersproject/constants';
import { Address, DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import {
  CONTRACT_NAMES,
  SAFE_ADDRESS,
  expiryPeriod,
} from "../config/constants";
import { Safe } from "../typechain-types";
import { checkForUndefined } from '@chain-labs/utils';
import { arrayify } from 'ethers/lib/utils';

const contractName = CONTRACT_NAMES.SIGNATURE_ALLOWANCE;

const deploySignatureAllowance: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
): Promise<void> => {
  // destructre HRE
  const { ethers, network, deployments, upgrades } = hre;

  // get signers
  const [deployer] = await ethers.getSigners();

  // destructure deployments object
  const { save, getExtendedArtifact, deploy } = deployments;

  // get safe address for currect network
  const safeAddress: Address = SAFE_ADDRESS(network.name);

  // deploy GM token
  const { address: gmToken } = await deploy(CONTRACT_NAMES.GM, {
    from: deployer.address,
    args: [safeAddress],
    log: true,
  });

  // prepare arguments
  const args = [safeAddress, gmToken, expiryPeriod];

  // deploy library
  const { address: LibAddress } = await deploy(
    CONTRACT_NAMES.CONTRACT_CHECKER,
    {
      from: deployer.address,
      args: [],
      log: true,
    }
  );

  // get contract factory
  const factory = await ethers.getContractFactory(contractName, {
    signer: deployer,
    libraries: { ContractChecker: LibAddress },
  });

  console.log(
    `Deploying ${contractName} on network ${network.name} using address ${deployer.address}`
  );

  // deploy
  const signatureAllowance = await upgrades.deployProxy(factory, args, {
    kind: "uups",
    unsafeAllow: ["external-library-linking"],
  });
  await signatureAllowance.deployed();

  // SignatureAllowance
  const SignatureAllowanceArtifact = await getExtendedArtifact(contractName);
  await save(contractName, {
    ...SignatureAllowanceArtifact,
    address: signatureAllowance.address,
  });
  console.log(`${contractName} Artifacts Saved`);

  // enable module at safe
  console.log(`Enabling module ${signatureAllowance.address} on ${safeAddress}`);
  const safeInstance = await ethers.getContractAt(CONTRACT_NAMES.SAFE, safeAddress) as Safe;

  // generate data for enable module
  const targetTrxData = await safeInstance.populateTransaction.enableModule(signatureAllowance.address);

  checkForUndefined("Transaction.data", targetTrxData.data);
  const currentNonce = await safeInstance.nonce();
  const trxHash = await safeInstance.getTransactionHash(safeInstance.address, 0, targetTrxData.data, 0, 0, 0, 0, AddressZero, AddressZero, currentNonce);
  const signature = (await deployer.signMessage(arrayify(trxHash))).replace(/1b$/, "1f")
  .replace(/1c$/, "20");
  // make transaction on safe
  try{
    const transaction = await safeInstance.execTransaction(safeInstance.address, 0, targetTrxData.data, 0, 0, 0, 0, AddressZero, AddressZero, signature);
    const receipt = await transaction.wait();
  } catch (e) {
    console.log("Some error occured. Please add Module manually");
  }

  // check if module is enabled
  const isEnabled = await safeInstance.isModuleEnabled(signatureAllowance.address);
  if(!isEnabled) {
    console.log(`Module not enabled, please manually enable it`);
  } else {
    console.log(`Module enabled at safe`);
  }

  // verify contract
  await new Promise((resolve, reject) => {
    setTimeout(async () => {
      // Verify Contract on etherscan
      console.log("Verifying contract on Etherscan");
      if (network.name === "hardhat" || network.name === "localhost") {
        console.log("Etherscan doesn't support network");
      } else {
        try {
          // SignatureAllowance
          await hre.run("verify:verify", {
            address: signatureAllowance.address,
          });
          // ContractChecker
          await hre.run("verify:verify", {
            address: LibAddress,
          });
          // GM token
          await hre.run("verify:verify", {
            address: gmToken,
            constructorArguments: [safeAddress]
          });
        } catch (e) {
          console.log(e);
        }
        console.log("Contract Verified");
      }
      resolve(1);
    }, 15000);
  });
};

deploySignatureAllowance.tags = [contractName];
export default deploySignatureAllowance;
