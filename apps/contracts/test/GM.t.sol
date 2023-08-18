// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import "../src/GM.sol";
import {SafeProxyFactory} from "@safe-global/safe-contracts/contracts/proxies/SafeProxyFactory.sol";
import {Safe} from "@safe-global/safe-contracts/contracts/Safe.sol";
import {TokenCallbackHandler} from "@safe-global/safe-contracts/contracts/handler/TokenCallbackHandler.sol";

contract GMTest is Test {
    uint256 constant public hundredMillion = 100_000_000;
    GM public gm;
    Safe public safe;
    address[] public _owners;
    // cannot use address(0x1) because SENTINEL_OWNERS address is address(0x1)
    address public safeSigner1 = address(0x9);

    function setUp() public {
        // initialise SafeProxy
        Safe _safe = new Safe();
        SafeProxyFactory _safeProxyFactory = new SafeProxyFactory();

        // token receive fallback handler
        TokenCallbackHandler _fallbackHandler = new TokenCallbackHandler();

        // currently no random salt required for salt
        uint256 saltNonce = 1;

        // initialise variables
        _owners.push(safeSigner1);
        uint256 _threshold = 1;
        address to;
        bytes memory data;
        address fallbackHandler = address(_fallbackHandler);
        address paymentToken;
        uint256 payment;
        address payable paymentReceiver;

        // generate initializer data
        bytes memory initalizer = abi.encodeWithSelector(
            Safe.setup.selector,
            _owners,
            _threshold,
            to,
            data,
            fallbackHandler,
            paymentToken,
            payment,
            paymentReceiver
        );

        // deploy Safe
        safe = Safe(
            payable(
                _safeProxyFactory.createProxyWithNonce(
                    address(_safe),
                    initalizer,
                    saltNonce
                )
            )
        );

        // create GM token and mint hundred million tokens to Safe
        gm = new GM(address(safe));
    }

    function testInitialise() public {

        // check balance of safe
        uint256 safesBalance = gm.balanceOf(address(safe));
        assertEq(safesBalance, hundredMillion);
    }
}
