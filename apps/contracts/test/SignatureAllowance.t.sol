// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {SignatureAllowance, Enum} from "../src/SignatureAllowance/SignatureAllowance.sol";
import {ContractChecker, ModuleManager, SafeModule} from "../src/SafeModule/SafeModule.sol";
import {GM, ERC20} from "../src/GM.sol";
import {MockToken} from "../src/MockToken.sol";
import {SetupSafe, Safe} from "./utils/SetupSafe.s.sol";

contract SignatureAllowanceTest is Test {
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

        // setup safe
        safe = (new SetupSafe()).setUp(signerAccount);

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

        // ensure the module is enabled on safe
        startHoax(signerAccount);

        uint256 nonce = safe.nonce();

        // prepare params
        bytes memory data = abi.encodeWithSelector(
            ModuleManager.enableModule.selector,
            address(signatureAllowance)
        );
        // get trxHash
        bytes32 trxHash = safe.getTransactionHash(
            address(safe),
            0,
            data,
            Enum.Operation.Call,
            0,
            0,
            0,
            address(0),
            payable(address(0)),
            nonce
        );

        bytes memory signature = _signMessageEOA(trxHash, signerPrivateKey);

        // enable module on safe
        safe.execTransaction(
            address(safe),
            0,
            data,
            Enum.Operation.Call,
            0,
            0,
            0,
            address(0),
            payable(address(0)),
            signature
        );

        // ensure the module is enabled on safe
        assertTrue(safe.isModuleEnabled(address(signatureAllowance)));
    }

    function testInitializer() public {
        console2.log(
            "SignatureAllowance: initialization of SignatureAllowance"
        );
        // deploy new signatureAllowance
        SignatureAllowance newSignatureAllowance = new SignatureAllowance();
        // initialize signature allowance
        newSignatureAllowance.initialize(
            safe,
            address(defaultToken),
            expiryPeriod
        );
        assertEq(newSignatureAllowance.defaultToken(), address(defaultToken));

        console2.log(
            "SignatureAllowance [Passed]: initialization of SignatureAllowance"
        );
    }

    function testUserCannotRemoveTokenNotAllowlisted() public {
        console2.log(
            "SignatureAllowance: User trying to remove token that isn't added to allowlist"
        );
        // create new token
        MockToken tokenToBeRemoved = new MockToken();
        // expect revert when trying to remove the token from allowlist
        vm.expectRevert(SignatureAllowance.TokenNotInAllowlist.selector);
        signatureAllowance.removeTokenFromAllowlist(address(tokenToBeRemoved));

        // ensure token is not added to allowlist
        assertFalse(
            signatureAllowance.checkTokenAllowlisted(address(tokenToBeRemoved))
        );
        console2.log(
            "SignatureAllowance [Passed]: User cannot remove token that is not in allowlist"
        );
    }

    function testUserTryingToAddTokenNotAllowlisted() public {
        console2.log(
            "SignatureAllowance: User trying to add token that isn't added to allowlist"
        );
        // create new token
        MockToken tokenToBeAdded = new MockToken();
        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(address(tokenToBeAdded));

        // ensure token is added to allowlist
        assertTrue(
            signatureAllowance.checkTokenAllowlisted(address(tokenToBeAdded))
        );
        console2.log(
            "SignatureAllowance [Passed]: User can add token that is not in allowlist"
        );
    }

    function testUserCannotAddTokenAlreadyAllowlisted() public {
        console2.log(
            "SignatureAllowance: User trying to add token that is added to allowlist"
        );
        // create new token
        address tokenToBeAdded = address(new MockToken());

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(tokenToBeAdded);

        // ensure token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeAdded));

        // expect revert when adding token to allowlist while the token is already in allowlist
        vm.expectRevert(SignatureAllowance.TokenAlreadyInAllowlist.selector);
        signatureAllowance.addTokenToAllowlist(tokenToBeAdded);

        // ensure token is still in allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeAdded));
        console2.log(
            "SignatureAllowance [Passed]: User cannot add token that is in allowlist"
        );
    }

    function testUserTryingToRemoveTokenAlreadyAllowlisted() public {
        console2.log(
            "SignatureAllowance: User trying to remove token that is added to allowlist"
        );
        // create new token
        address tokenToBeRemoved = address(new MockToken());

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(tokenToBeRemoved);

        // ensure token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(tokenToBeRemoved));

        // expect revert when trying to remove the token from allowlist
        signatureAllowance.removeTokenFromAllowlist(tokenToBeRemoved);

        // ensure token is remove
        assertFalse(signatureAllowance.checkTokenAllowlisted(tokenToBeRemoved));
        console2.log(
            "SignatureAllowance [Passed]: User can remove token that is in allowlist"
        );
    }

    function testUserTryingToSetNewValidContractAsSafe() public {
        // deploy new safe
        Safe newSafe = (new SetupSafe()).setUp(signerAccount);

        // update safe
        signatureAllowance.setNewSafe(newSafe);

        // get current safe address
        address currentSafeAddress = address(signatureAllowance.getSafe());

        // ensure safe address is newly updated
        assertEq(currentSafeAddress, address(newSafe));
    }

    function testUserCannotSetNewInvalidContractAsSafe() public {
        // use an address that is not contract
        address eoa = address(0x202);

        // expect revert when the address is not a contract
        vm.expectRevert(
            abi.encodeWithSelector(ContractChecker.NotAContract.selector, eoa)
        );
        // trying to pass EOA address as payable
        signatureAllowance.setNewSafe(Safe(payable(eoa)));

        // get current safe address
        address currentSafeAddress = address(signatureAllowance.getSafe());

        // ensure the safe address haven't changed
        assertEq(currentSafeAddress, address(safe));
    }

    function testUserReadingSafeContractAddress() public {
        // get safe
        Safe currentSafe = signatureAllowance.getSafe();

        // safe address should be equal to safe address set initially
        assertEq(address(currentSafe), address(safe));
    }

    function testUserReadingExpiryPeriod() public {
        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance
            .getSignatureExpiryPeriod();

        // current expiry periods should be equal to new expiry period
        assertEq(currentExpiryPeriod, expiryPeriod);
    }

    function testUserSettingNewExpiryPeriod() public {
        // initialise new expiry period
        uint256 newExpiryPeriod = 2 hours;

        // set new expiry period
        signatureAllowance.setSignatureExpiryPeriod(newExpiryPeriod);

        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance
            .getSignatureExpiryPeriod();

        // check if new expiry period is updated
        assertEq(currentExpiryPeriod, newExpiryPeriod);
    }

    function testUserAddingNewDefaultTokenAlreadyAllowlisted() public {
        // deploy new mock token to be added as default token
        address newDefaultToken = address(new MockToken());

        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(newDefaultToken);

        // ensure new mock token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(newDefaultToken));

        // ensure new allowlisted token is not default token
        assertNotEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // set new default token
        signatureAllowance.setNewDefaultToken(newDefaultToken);

        // ensure new token is added as new default token
        assertEq(newDefaultToken, signatureAllowance.getDefaultToken());
    }

    function testUserAddingNewDefaultTokenNotAllowlisted() public {
        // deploy new mock token to be added as default token
        address newDefaultToken = address(new MockToken());

        // ensure new mock token is not allowlisted
        assertFalse(signatureAllowance.checkTokenAllowlisted(newDefaultToken));

        // ensure new allowlisted token is not default token
        assertNotEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // set new default token
        signatureAllowance.setNewDefaultToken(newDefaultToken);

        // ensure new token is added as new default token
        assertEq(newDefaultToken, signatureAllowance.getDefaultToken());

        // ensure new default token is allowlisted
        assertTrue(signatureAllowance.checkTokenAllowlisted(newDefaultToken));
    }

    function testValidSignatureFromSigner() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(messageHash, signerPrivateKey);
        console2.logBytes(signature);
        // check signatures
        bool isValid = signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            to,
            creationTime,
            _salt
        );
        console2.log(isValid);
    }

    function testInvalidSignatureFromNonOwner() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(
            messageHash,
            nonSignerPrivateKey
        );
        // check signatures
        // expect revert with GS026 error that is signer is not owner
        vm.expectRevert("GS026");
        bool isValid = signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            to,
            creationTime,
            _salt
        );
    }

    function testInvalidSignatureAfterExpiry() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(
            messageHash,
            nonSignerPrivateKey
        );

        // fast forward into time to cross expiry time
        vm.warp(
            block.timestamp + signatureAllowance.getSignatureExpiryPeriod() + 1
        );
        // check signatures
        // expect revert with SignatureInactive error after expiry period
        vm.expectRevert(SignatureAllowance.SignatureInactive.selector);
        bool isValid = signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            to,
            creationTime,
            _salt
        );
    }

    function testInvalidSignatureExactlyAtExpiry() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(messageHash, signerPrivateKey);

        // fast forward into time to cross expiry time
        {
            uint256 currentExpiryPeriod = signatureAllowance
                .getSignatureExpiryPeriod();
            vm.warp(creationTime + currentExpiryPeriod);
        }
        // check signatures
        bool isValid = signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            to,
            creationTime,
            _salt
        );
    }

    function testWithdrawWithValidSignature() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = nonSignerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(messageHash, signerPrivateKey);

        signatureAllowance.withdrawAllowanceFromToken(
            amount,
            nonSignerAccount,
            signature,
            to,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount);
    }

    function testWithdrawDefaultWithValidSignature() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = nonSignerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(messageHash, signerPrivateKey);

        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            nonSignerAccount,
            signature,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount);
    }

    function testWithdrawDefaultWithUsedSalt() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 amount = 100 ether;
        address withdrawer = nonSignerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            amount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(messageHash, signerPrivateKey);

        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            nonSignerAccount,
            signature,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount);

        // use same signature again
        vm.expectRevert(abi.encodeWithSelector(SignatureAllowance.SaltAlreadyUsed.selector, _salt));
        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            nonSignerAccount,
            signature,
            creationTime,
            _salt
        );
    }

    function testSafeModuleSafelyReverts() public {
        // generate params
        bytes32 messageHash;
        address to = address(defaultToken);
        uint256 value = 0;
        uint256 invalidAmount = 100_000_000_000 ether;
        address withdrawer = nonSignerAccount;
        bytes memory data = abi.encodeWithSelector(
            ERC20.transfer.selector,
            withdrawer,
            invalidAmount
        );
        Enum.Operation operation = Enum.Operation.Call;
        uint256 creationTime = block.timestamp;
        uint256 _salt = currentSalt;
        currentSalt++;
        {
            // generate encoded message data
            bytes memory messageHashData = signatureAllowance
                .encodeTransactionData(
                    to,
                    value,
                    data,
                    operation,
                    creationTime,
                    _salt
                );
            // generate message hash
            messageHash = keccak256(messageHashData);
        }
        // sign message hash
        bytes memory signature = _signMessageEOA(messageHash, signerPrivateKey);

        // use same signature again
        vm.expectRevert(SafeModule.ModuleExecutionFailed.selector);
        signatureAllowance.withdrawAllowanceDefaultToken(
            invalidAmount,
            nonSignerAccount,
            signature,
            creationTime,
            _salt
        );
    }

    function testWithdrawSecondaryToken() public {
        MockToken mockToken = new MockToken();
        mockToken.mint(address(safe));
    }

    function _signMessageEOA(
        bytes32 txHash,
        uint256 _signerPrivateKey
    ) internal returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_signerPrivateKey, txHash);
        return abi.encodePacked(r, s, v);
    }
}
