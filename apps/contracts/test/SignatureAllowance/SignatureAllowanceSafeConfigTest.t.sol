/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceSafeConfigTest is SignatureAllowanceSetup {

    bytes32 private constant ACCOUNT_HASH =
        0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

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

    function testUserCannotSetNewInvalidContractAsSafe(address newInvalidSafe) public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));

        bytes32 extCodeHash;

        assembly {
            extCodeHash := extcodehash(newInvalidSafe)
        }

        vm.assume(!(extCodeHash != ACCOUNT_HASH && extCodeHash != 0x0));

        // expect revert when the address is not a contract
        vm.expectRevert(
            abi.encodeWithSelector(ContractChecker.NotAContract.selector, newInvalidSafe)
        );
        // trying to pass newInvalidSafe address as payable
        signatureAllowance.setNewSafe(Safe(payable(newInvalidSafe)));

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
