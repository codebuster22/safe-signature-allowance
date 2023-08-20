/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceSafeConfigTest is SignatureAllowanceSetup {
    function testUserTryingToSetNewValidContractAsSafe() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        // deploy new safe
        Safe newSafe = (new SetupSafe()).setUp(signerAccount);

        // update safe
        signatureAllowance.setNewSafe(newSafe);

        // get current safe address
        address currentSafeAddress = address(signatureAllowance.getSafe());

        // ensure safe address is newly updated
        assertEq(currentSafeAddress, address(newSafe));
    }

    function testNonSignerTryingToSetNewValidContractAsSafe() public {
        startHoax(nonSignerAccount);
        // deploy new safe
        Safe newSafe = (new SetupSafe()).setUp(signerAccount);

        // update safe
        // expect revert as the caller is not the owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.setNewSafe(newSafe);

        // get current safe address
        address currentSafeAddress = address(signatureAllowance.getSafe());

        // ensure safe address is newly updated
        assertNotEq(currentSafeAddress, address(newSafe));
        // ensure safe address haven't changed
        assertEq(currentSafeAddress, address(safe));
    }

    function testUserCannotSetNewInvalidContractAsSafe() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
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
}