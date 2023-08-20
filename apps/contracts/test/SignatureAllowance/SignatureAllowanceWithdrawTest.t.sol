/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceWithdrawTest is SignatureAllowanceSetup {
    function testWithdrawWithValidSignature(uint256 amount, address withdrawer) public {
        // generate params
        vm.assume(amount <= defaultToken.balanceOf(address(safe)));
        vm.assume(withdrawer != address(0));
        vm.assume(withdrawer != address(safe));
        uint256 initialBalance = defaultToken.balanceOf(withdrawer);
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

        signatureAllowance.withdrawAllowanceFromToken(
            amount,
            withdrawer,
            signature,
            token,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount + initialBalance);
    }

    function testWithdrawDefaultWithValidSignature(uint256 amount, address withdrawer) public {
        // generate params
        vm.assume(amount <= defaultToken.balanceOf(address(safe)));
        vm.assume(withdrawer != address(0));
        vm.assume(withdrawer != address(safe));
        uint256 initialBalance = defaultToken.balanceOf(withdrawer);
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

        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            withdrawer,
            signature,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount + initialBalance);
    }

    function testWithdrawDefaultWithUsedSalt(uint256 amount, address withdrawer) public {
        // generate params
        vm.assume(amount <= defaultToken.balanceOf(address(safe)));
        vm.assume(withdrawer != address(0));
        vm.assume(withdrawer != address(safe));
        uint256 initialBalance = defaultToken.balanceOf(withdrawer);
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

        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            withdrawer,
            signature,
            creationTime,
            _salt
        );
        assertEq(defaultToken.balanceOf(withdrawer), amount + initialBalance);

        // use same signature again
        vm.expectRevert(
            abi.encodeWithSelector(
                SignatureAllowance.SaltAlreadyUsed.selector,
                _salt
            )
        );
        signatureAllowance.withdrawAllowanceDefaultToken(
            amount,
            withdrawer,
            signature,
            creationTime,
            _salt
        );
    }

    function testSafeModuleSafelyReverts(uint256 invalidAmount, address withdrawer) public {
        // generate params
        vm.assume(invalidAmount > defaultToken.balanceOf(address(safe)));
        vm.assume(withdrawer != address(0));
        vm.assume(withdrawer != address(safe));
        address token = address(defaultToken);
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
            withdrawer,
            signature,
            creationTime,
            _salt
        );
    }

    function testWithdrawSecondaryToken(uint256 amount, address withdrawer) public {
        MockToken mockToken = new MockToken();
        mockToken.mint(address(safe));
        uint256 initialBalance = mockToken.balanceOf(withdrawer);

        vm.assume(amount <= mockToken.balanceOf(address(safe)));
        vm.assume(withdrawer != address(0));
        vm.assume(withdrawer != address(safe));

        // add token to allowlist
        hoax(address(safe));
        signatureAllowance.addTokenToAllowlist(address(mockToken));
        address token = address(mockToken);
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

        // use same signature again
        signatureAllowance.withdrawAllowanceFromToken(
            amount,
            withdrawer,
            signature,
            address(mockToken),
            creationTime,
            _salt
        );
        assertEq(mockToken.balanceOf(withdrawer), amount + initialBalance);
    }

    function testWithdrawTokenNotInAllowlist(uint256 amount, address withdrawer) public {
        MockToken mockToken = new MockToken();
        mockToken.mint(address(safe));

        vm.assume(amount < mockToken.balanceOf(address(safe)));
        vm.assume(withdrawer != address(0));
        vm.assume(withdrawer != address(safe));
        address token = address(mockToken);
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

        // use same signature again
        vm.expectRevert(SignatureAllowance.TokenNotInAllowlist.selector);
        signatureAllowance.withdrawAllowanceFromToken(
            amount,
            withdrawer,
            signature,
            token,
            creationTime,
            _salt
        );
    }
}
