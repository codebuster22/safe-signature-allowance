/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceExpiryTimeTest is SignatureAllowanceSetup {
    function testUserReadingExpiryPeriod() public {
        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance
            .getSignatureExpiryPeriod();

        // current expiry periods should be equal to new expiry period
        assertEq(currentExpiryPeriod, expiryPeriod);
    }

    function testUserSettingNewExpiryPeriod() public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
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

    function testNonSignerSettingNewExpiryPeriod() public {
        startHoax(nonSignerAccount);
        // initialise new expiry period
        uint256 newExpiryPeriod = 2 hours;

        // set new expiry period
        // expect revert as caller is not owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.setSignatureExpiryPeriod(newExpiryPeriod);

        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance
            .getSignatureExpiryPeriod();

        // check if new expiry period is updated
        assertNotEq(currentExpiryPeriod, newExpiryPeriod);
        // ensure the expiry period is still the same
        assertEq(currentExpiryPeriod, expiryPeriod);
    }
}
