/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceSafeConfigTest is SignatureAllowanceSetup {
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
}