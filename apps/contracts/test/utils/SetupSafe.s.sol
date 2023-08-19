// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {SafeProxyFactory} from "@safe-global/safe-contracts/contracts/proxies/SafeProxyFactory.sol";
import {Safe} from "@safe-global/safe-contracts/contracts/Safe.sol";
import {TokenCallbackHandler} from "@safe-global/safe-contracts/contracts/handler/TokenCallbackHandler.sol";
import {Enum} from "../../src/SignatureAllowance/SignatureAllowance.sol";
import {ModuleManager} from "@safe-global/safe-contracts/contracts/base/ModuleManager.sol";

contract SetupSafe {
    address[] public owners;

    function setUp(address signerAddress) public returns (Safe safe) {
        // initialise SafeProxy
        Safe _safe = new Safe();
        SafeProxyFactory _safeProxyFactory = new SafeProxyFactory();

        // token receive fallback handler
        TokenCallbackHandler _fallbackHandler = new TokenCallbackHandler();

        // currently no random salt required for salt
        uint256 saltNonce = 1;

        // initialise variables
        owners.push(signerAddress);
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
            owners,
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
    }

    function getTxHashAndDataForEnableModule(Safe safe, address module) view public returns(bytes32 trxHash, bytes memory data) {
        // ensure the module is enabled on safe

        // get current safe nonce
        uint256 nonce = safe.nonce();

        // prepare params for enabling module
        data = abi.encodeWithSelector(
            ModuleManager.enableModule.selector,
            module
        );

        // get trxHash
        trxHash = safe.getTransactionHash(
            address(safe),
            0, // value = 0
            data,
            Enum.Operation.Call,
            0, // safeTrxGas = 0
            0, // baseGas = 0
            0, // gasPrice = 0
            address(0), // gasToken = 0
            payable(address(0)), // refundReceiver = 0
            nonce
        );
    }
}