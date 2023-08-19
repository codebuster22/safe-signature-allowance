/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {SafeModule, Enum, Initializable, Safe} from "../SafeModule/SafeModule.sol";
import {SignatureAllowanceStorage} from "./SignatureAllowanceStorage.sol";
import {ISignatureAllowance} from "../interfaces/ISignatureAllowance.sol";

contract SignatureAllowance is SafeModule, SignatureAllowanceStorage {
    error SaltAlreadyUsed(uint256 salt);

    // initialize 
    function initialize(Safe _safe, address _defaultToken) external initializer {
        __SafeModule_init(_safe);
        tokensAllowed[_defaultToken] = true;
        defaultToken = _defaultToken;

        // ensure default salt value (0) is used by default
        // to prevent unknown errors due to default values
        saltUsed[0] = true;
    }

    // check signatures reaches threshold on Safe
    // reverts if signature is invalid
    // returns true if valid
    function _checkSignaturesValidity(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 salt,
        bytes memory _sigantures,
        Safe safe
    ) internal view returns (bool) {
        bytes memory txHashData = safe.encodeTransactionData(
            to,
            value,
            data,
            operation,
            0,
            0,
            0,
            address(0),
            address(0),
            salt
        );
        // Increase nonce and execute transaction.
        bytes32 txHash = keccak256(txHashData);
        // if signature is invalid, checkSignatures will revert
        safe.checkSignatures(txHash, txHashData, _sigantures);
        // if checkSignatures didn't revert that means, signature is valid
        return true;
    }
}