// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import "../src/GM.sol";
import {SetupSafe, Safe} from "./utils/SetupSafe.s.sol";

contract GMTest is Test {
    uint256 public constant HUNDRED_MILLION = 100_000_000 ether;
    GM public gm;
    Safe public safe;

    // Wallet signerAccount;
    address public signerAccount;
    uint256 public signerPrivateKey;

    function setUp() public {
        // create wallet
        (signerAccount, signerPrivateKey) = makeAddrAndKey("SignerAccount");
        safe = (new SetupSafe()).setUp(signerAccount);
        // create GM token and mint hundred million tokens to Safe
        gm = new GM(address(safe));
    }

    function testInitialise() public {
        // check balance of safe
        uint256 safesBalance = gm.balanceOf(address(safe));
        assertEq(safesBalance, HUNDRED_MILLION);
    }
}
