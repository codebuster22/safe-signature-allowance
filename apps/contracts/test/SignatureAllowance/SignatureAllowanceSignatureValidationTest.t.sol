/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceSignatureValidationTest is SignatureAllowanceSetup {
    uint256 private constant MAX_PRIVATE_KEY_VALUE =
        115792089237316195423570985008687907852837564279074904382605163141518161494337;

    function testValidSignatureFromSigner(
        uint256 amount,
        address withdrawer
    ) public {
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

    function testInvalidSignatureFromNonOwner(
        uint256 amount,
        address withdrawer,
        uint256 _nonSignerPrivateKey
    ) public {
        vm.assume(_nonSignerPrivateKey != signerPrivateKey);
        vm.assume(_nonSignerPrivateKey != 0);
        vm.assume(_nonSignerPrivateKey < MAX_PRIVATE_KEY_VALUE);
        // generate params
        address token = address(defaultToken);
        (
            bytes memory signature,
            uint256 creationTime,
            uint256 _salt
        ) = processAndGenerateSignature(
                amount,
                withdrawer,
                token,
                _nonSignerPrivateKey
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

    function testInvalidSignatureAfterExpiry(
        uint256 amount,
        address withdrawer
    ) public {
        // generate params
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

    function testValidSignatureExactlyAtExpiry(
        uint256 amount,
        address withdrawer
    ) public {
        // generate params
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
