/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceWithdrawTest is SignatureAllowanceSetup {
    function testWithdrawWithValidSignature() public {
        // generate params
        address token = address(defaultToken);
        uint256 amount = 100 ether;
        address withdrawer = nonSignerAccount;
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

        signatureAllowance.withdrawAllowanceFromToken(
            amount,
            nonSignerAccount,
            signature,
            token,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount);
    }

    function testWithdrawDefaultWithValidSignature() public {
        // generate params
        address token = address(defaultToken);
        uint256 amount = 100 ether;
        address withdrawer = nonSignerAccount;
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
        address token = address(defaultToken);
        uint256 amount = 100 ether;
        address withdrawer = nonSignerAccount;
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

        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            nonSignerAccount,
            signature,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount);

        // use same signature again
        vm.expectRevert(
            abi.encodeWithSelector(
                SignatureAllowance.SaltAlreadyUsed.selector,
                _salt
            )
        );
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
        address token = address(defaultToken);
        uint256 invalidAmount = 100_000_000_000 ether;
        address withdrawer = nonSignerAccount;
        (
            bytes memory signature,
            uint256 creationTime,
            uint256 _salt
        ) = processAndGenerateSignature(
                invalidAmount,
                withdrawer,
                token,
                signerPrivateKey
            );

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
}
