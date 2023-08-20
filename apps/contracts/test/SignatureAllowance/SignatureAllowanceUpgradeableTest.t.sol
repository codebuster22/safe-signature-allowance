/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./SignatureAllowanceSetup.t.sol";

contract SignatureAllowanceUpgradeableTest is SignatureAllowanceSetup {
    function testSignerUpgrade() public {
        startHoax(address(safe));

        // consider this to be a new version of Signature allowance
        // currently expecting no statevariable addition
        address newImplementation = address(new SignatureAllowance());

        signatureAllowance.upgradeTo(newImplementation);
    }

    function testNonSignerUpgrade() public {
        startHoax(nonSignerAccount);

        // consider this to be a new version of Signature allowance
        // currently expecting no statevariable addition
        address newImplementation = address(new SignatureAllowance());

        // expect revert because only owner can upgrade
        vm.expectRevert("Ownable: caller is not the owner");
        signatureAllowance.upgradeTo(newImplementation);
    }
}