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

    function testUserSettingNewExpiryPeriod(uint256 _expiryTime) public {
        // taking an easier approach in testing by impersonating Safe
        startHoax(address(safe));
        // initialise new expiry period

        // set new expiry period
        signatureAllowance.setSignatureExpiryPeriod(_expiryTime);

        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance
            .getSignatureExpiryPeriod();

        // check if new expiry period is updated
        assertEq(currentExpiryPeriod, _expiryTime);
    }

    function testNonSignerSettingNewExpiryPeriod(uint256 _expiryPeriod) public {
        vm.assume(_expiryPeriod != expiryPeriod);
        startHoax(nonSignerAccount);

        // set new expiry period
        // expect revert as caller is not owner
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.setSignatureExpiryPeriod(_expiryPeriod);

        // get current expiry period
        uint256 currentExpiryPeriod = signatureAllowance
            .getSignatureExpiryPeriod();

        // check if new expiry period is updated
        assertNotEq(currentExpiryPeriod, _expiryPeriod);
        // ensure the expiry period is still the same
        assertEq(currentExpiryPeriod, expiryPeriod);
    }
}
