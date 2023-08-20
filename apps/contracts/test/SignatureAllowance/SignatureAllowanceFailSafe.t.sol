/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceFailSafe is SignatureAllowanceSetup {
    function testSignerActivatingFailSafe() public {
        startHoax(address(safe));

        signatureAllowance.pause();

        assertTrue(signatureAllowance.paused());

        // once fail safe is activated, user cannot deactivate it again
        vm.expectRevert("Pausable: paused");
        signatureAllowance.pause();

        assertTrue(signatureAllowance.paused());

    }

    function testSignerDeactivatingFailSafe() public {
        startHoax(address(safe));

        // initially activate the fail safe\
        signatureAllowance.pause();

        // once the fail safe is active now deactivate it
        signatureAllowance.unpause();

        assertFalse(signatureAllowance.paused());

        // once fail safe is deactivated, user cannot deactivate it again
        vm.expectRevert("Pausable: not paused");
        signatureAllowance.unpause();

        assertFalse(signatureAllowance.paused());

    }

    function testNonSignerActivatingFailSafe() public {
        startHoax(nonSignerAccount);

        // expect revert as caller is not the owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.pause();
    }

    function testNonSignerDeactivatingFailSafe() public {
        // initially activate the fail safe
        hoax(address(safe));
        signatureAllowance.pause();

        // expect revert as caller is not the owner
        hoax(nonSignerAccount);
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.unpause();
    }
}