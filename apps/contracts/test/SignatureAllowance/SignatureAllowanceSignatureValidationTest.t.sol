/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceSignatureValidationTest is SignatureAllowanceSetup {
    function testValidSignatureFromSigner() public {
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        address token = address(defaultToken);
        (
            bytes memory signature,
            uint256 creationTime,
            uint256 _salt
        ) = processAndGenerateSignature(
                amount,
                withdrawer,
                token,
                signerPrivateKey
            );

        // check signatures
        bool isValid = signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            token,
            creationTime,
            _salt
        );

        assertTrue(isValid);
    }

    function testInvalidSignatureFromNonOwner() public {
        // generate params
        address token = address(defaultToken);
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        (
            bytes memory signature,
            uint256 creationTime,
            uint256 _salt
        ) = processAndGenerateSignature(
                amount,
                withdrawer,
                token,
                nonSignerPrivateKey
            );
        // check signatures
        // expect revert with GS026 error that is signer is not owner
        vm.expectRevert("GS026");
        signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            token,
            creationTime,
            _salt
        );
    }

    function testInvalidSignatureAfterExpiry() public {
        // generate params
        address token = address(defaultToken);
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        (
            bytes memory signature,
            uint256 creationTime,
            uint256 _salt
        ) = processAndGenerateSignature(
                amount,
                withdrawer,
                token,
                signerPrivateKey
            );

        // fast forward into time to cross expiry time
        vm.warp(
            creationTime + signatureAllowance.getSignatureExpiryPeriod() + 1
        );
        // check signatures
        // expect revert with SignatureInactive error after expiry period
        vm.expectRevert(SignatureAllowance.SignatureInactive.selector);
        signatureAllowance.isSignatureValid(
            amount,
            withdrawer,
            signature,
            token,
            creationTime,
            _salt
        );
    }

    function testValidSignatureExactlyAtExpiry() public {
        // generate params
        address token = address(defaultToken);
        uint256 amount = 100 ether;
        address withdrawer = signerAccount;
        (
            bytes memory signature,
            uint256 creationTime,
            uint256 _salt
        ) = processAndGenerateSignature(
                amount,
                withdrawer,
                token,
                signerPrivateKey
            );

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
            token,
            creationTime,
            _salt
        );

        assertTrue(isValid);
    }
}
