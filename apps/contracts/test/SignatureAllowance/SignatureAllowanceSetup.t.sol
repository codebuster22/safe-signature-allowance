// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {SignatureAllowance, Enum} from "../../src/SignatureAllowance/SignatureAllowance.sol";
import {ContractChecker, ModuleManager, SafeModule} from "../../src/SafeModule/SafeModule.sol";
import {GM, ERC20} from "../../src/GM.sol";
import {MockToken} from "../../src/MockToken.sol";
import {SetupSafe, Safe} from "../utils/SetupSafe.s.sol";

contract SignatureAllowanceSetup is Test {
    SignatureAllowance public signatureAllowance;
    Safe public safe;
    GM public defaultToken;
    uint256 public expiryPeriod;
    // Wallet signerAccount;
    address public signerAccount;
    uint256 public signerPrivateKey;

    // Wallet nonSignerAccount
    address public nonSignerAccount;
    uint256 public nonSignerPrivateKey;

    uint256 public currentSalt;

    function setUp() public {
        // create wallet
        (signerAccount, signerPrivateKey) = makeAddrAndKey("SignerAccount");
        (nonSignerAccount, nonSignerPrivateKey) = makeAddrAndKey(
            "NonSignerAccount"
        );
        expiryPeriod = 1 hours;
        currentSalt = 1;

        SetupSafe safeSetup = new SetupSafe();

        // setup safe
        safe = safeSetup.setUp(signerAccount);

        // setup default token
        defaultToken = new GM(address(safe));

        // deploy SignatureAllowance
        signatureAllowance = new SignatureAllowance();

        // initialize
        signatureAllowance.initialize(
            safe,
            address(defaultToken),
            expiryPeriod
        );

        (bytes32 trxHash, bytes memory data) = safeSetup
            .getTxHashAndDataForEnableModule(safe, address(signatureAllowance));

        // generate signature
        bytes memory signature = signMessageEOA(trxHash, signerPrivateKey);

        // enable module on safe
        safe.execTransaction(
            address(safe),
            0, // value = 0
            data,
            Enum.Operation.Call,
            0, // safeTrxGas = 0
            0, // baseGas = 0
            0, // gasPrice = 0
            address(0), // gasToken = 0
            payable(address(0)), // refundReceiver = 0
            signature
        );

        // ensure the module is enabled on safe
        assertTrue(safe.isModuleEnabled(address(signatureAllowance)));
    }

    function testInitializer() public {
        console2.log(
            "SignatureAllowance: initialization of SignatureAllowance"
        );
        SetupSafe safeSetup = new SetupSafe();

        Safe newSafe = safeSetup.setUp(signerAccount);
        // deploy new signatureAllowance
        SignatureAllowance newSignatureAllowance = new SignatureAllowance();
        // initialize signature allowance
        newSignatureAllowance.initialize(
            newSafe,
            address(defaultToken),
            expiryPeriod
        );
        assertEq(newSignatureAllowance.defaultToken(), address(defaultToken));

        // add new safe module to Safe
        (bytes32 trxHash, bytes memory data) = safeSetup
            .getTxHashAndDataForEnableModule(newSafe, address(newSignatureAllowance));

        // generate signature
        bytes memory signature = signMessageEOA(trxHash, signerPrivateKey);

        // enable module on safe
        newSafe.execTransaction(
            address(newSafe),
            0, // value = 0
            data,
            Enum.Operation.Call,
            0, // safeTrxGas = 0
            0, // baseGas = 0
            0, // gasPrice = 0
            address(0), // gasToken = 0
            payable(address(0)), // refundReceiver = 0
            signature
        );

        // ensure the module is enabled on safe
        assertTrue(newSafe.isModuleEnabled(address(newSignatureAllowance)));

        console2.log(
            "SignatureAllowance [Passed]: initialization of SignatureAllowance"
        );
    }

    function signMessageEOA(
        bytes32 txHash,
        uint256 _signerPrivateKey
    ) public pure returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_signerPrivateKey, txHash);
        return abi.encodePacked(r, s, v);
    }

    function processAndGenerateSignature(
        uint256 amount,
        address withdrawer,
        address to,
        uint256 _signerPrivateKey
    )
        public
        returns (bytes memory signature, uint256 creationTime, uint256 _salt)
    {
        // generate params
        bytes32 messageHash;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );

        Enum.Operation operation = Enum.Operation.Call;
        creationTime = block.timestamp;
        _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    0, // value = 0
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        signature = signMessageEOA(messageHash, _signerPrivateKey);
    }
}