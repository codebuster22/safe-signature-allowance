// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {SignatureAllowance} from "../src/SignatureAllowance/SignatureAllowance.sol";
import {ContractChecker} from "../src/SafeModule/SafeModule.sol";
import {GM} from "../src/GM.sol";
import {MockToken} from "../src/MockToken.sol";
import {SetupSafe, Safe} from "./utils/SetupSafe.s.sol";

contract SignatureAllowanceTest is Test {
    SignatureAllowance public signatureAllowance;
    Safe public safe;
    GM public defaultToken;
    uint256 public expiryPeriod = 1 hours;

    function setUp() public {
        // setup safe
        safe = (new SetupSafe()).setUp();

        // setup default token
        defaultToken = new GM(address(safe));

        // deploy SignatureAllowance
        signatureAllowance = new SignatureAllowance();
    }

    function testInitializer() public {
        console2.log("SignatureAllowance: initialization of SignatureAllowance");
        // initialize signature allowance
        signatureAllowance.initialize(safe, address(defaultToken), expiryPeriod);
        assertEq(signatureAllowance.defaultToken(), address(defaultToken));

        console2.log("SignatureAllowance [Passed]: initialization of SignatureAllowance");
    }

    function testUserCannotRemoveTokenNotAllowlisted() public {
        console2.log("SignatureAllowance: User trying to remove token that isn't added to allowlist");
        // create new token
        MockToken tokenToBeRemoved = new MockToken();
        // expect revert when trying to remove the token from allowlist
        vm.expectRevert(SignatureAllowance.TokenNotInAllowlist.selector);
        signatureAllowance.removeTokenFromAllowlist(address(tokenToBeRemoved));

        // ensure token is not added to allowlist
        assertFalse(signatureAllowance.checkTokenAllowlisted(address(tokenToBeRemoved)));
        console2.log("SignatureAllowance [Passed]: User cannot remove token that is not in allowlist");
    }

    function testUserTryingToAddTokenNotAllowlisted() public {
        console2.log("SignatureAllowance: User trying to add token that isn't added to allowlist");
        // create new token
        MockToken tokenToBeAdded = new MockToken();
        // add token to allowlist
        signatureAllowance.addTokenToAllowlist(address(tokenToBeAdded));

        // ensure token is added to allowlist
        assertTrue(signatureAllowance.checkTokenAllowlisted(address(tokenToBeAdded)));
        console2.log("SignatureAllowance [Passed]: User can add token that is not in allowlist");
    }

    function testUserCannotAddTokenAlreadyAllowlisted() public {
        console2.log("SignatureAllowance: User trying to add token that is added to allowlist");
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
        console2.log("SignatureAllowance [Passed]: User cannot add token that is in allowlist");
    }

    function testUserTryingToRemoveTokenAlreadyAllowlisted() public {
        console2.log("SignatureAllowance: User trying to remove token that is added to allowlist");
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
        console2.log("SignatureAllowance [Passed]: User can remove token that is in allowlist");
    }

    function testUserTryingToSetNewValidContractAsSafe() public {
        // deploy new safe
        Safe newSafe = (new SetupSafe()).setUp();

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
        vm.expectRevert(abi.encodeWithSelector(ContractChecker.NotAContract.selector, eoa));
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
        uint256 currentExpiryPeriod = signatureAllowance.getSignatureExpiryPeriod();

        // current expiry periods should be equal to new expiry period
        assertEq(currentExpiryPeriod, expiryPeriod);
    }

    function testUserSettingNewExpiryPeriod() public {
        // initialise new expiry period
        uint256 newExpiryPeriod = 2 hours;

        // set new expiry period
        signatureAllowance.setSignatureExpiryPeriod(newExpiryPeriod);

        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance.getSignatureExpiryPeriod();

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

}