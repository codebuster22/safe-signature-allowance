// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {SignatureAllowance} from "../src/SignatureAllowance/SignatureAllowance.sol";
import {GM} from "../src/GM.sol";
import {SetupSafe, Safe} from "./utils/SetupSafe.s.sol";

contract SignatureAllowanceTest is Test {
    SignatureAllowance public signatureAllowance;
    Safe public safe;
    GM public defaultToken;

    function setUp() public {
        // setup safe
        safe = (new SetupSafe()).setUp();

        // setup default token
        defaultToken = new GM(address(safe));

        // deploy SignatureAllowance
        signatureAllowance = new SignatureAllowance();
    }

    function testInitializer() public {
        console2.log("Test initialization of SignatureAllowance");
        // initialize signature allowance
        signatureAllowance.initialize(safe, address(defaultToken));
        assertEq(signatureAllowance.defaultToken(), address(defaultToken));
    }

}