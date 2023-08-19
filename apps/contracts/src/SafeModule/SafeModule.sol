/// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {ModuleManager} from "@safe-global/safe-contracts/contracts/base/ModuleManager.sol";
import {Safe, Enum} from "@safe-global/safe-contracts/contracts/Safe.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

/// @title Contarct Checker (Library)
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice a library to check if a address is a contract
/// @dev uses EXTCODEHASH to see if an address is a contract
library ContractChecker {
    /// When an address is not a contract
    error NotAContract(address invalidContract);

    /// @notice constant hash that is for address with no code
    bytes32 private constant ACCOUNT_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

    /// @notice check if an address is contract or not
    /// @dev uses EXTCODEHASH, if not a contract, reverts
    /// @param _addressToCheck address to check if it's a contract or not
    function checkIsContarct(address _addressToCheck) public view {
        // check if a valid contract
        bytes32 extCodeHash;

        assembly {
            extCodeHash := extcodehash(_addressToCheck)
        }

        if (!(extCodeHash != ACCOUNT_HASH && extCodeHash != 0x0)){
            revert NotAContract(_addressToCheck);
        }
    }
}

/// @title Safe Module
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice A base safe module to be used to create new Safe Module
/// @dev to be inherited to create more complex Safe Modules
abstract contract SafeModule is Initializable {
    /// @notice Logs when a safe module is initialized
    /// @dev Use this to index when a SafeModule is initialized
    event SafeModuleInitialized();

    /// @notice Logs when target safe is updated
    /// @dev Use this to index updates in target safe address
    /// @param prevSafe previous safe instance (address)
    /// @param newSafe new safe instance (address)
    event TargetSafeUpdated(Safe prevSafe, Safe newSafe);

    /// Call to Safe.executeTransactionFromModule reverted
    error ModuleExecutionFailed();

    /// @notice Target Safe where the module is enabled
    Safe private _safe;

    /// @notice Initialize safe module
    /// @dev can only be invoked in initialization function with initializer modifier
    /// @param _newSafe target safe instance
    function __SafeModule_init(Safe _newSafe) internal onlyInitializing {
        _setNewSafe(_newSafe);
        emit SafeModuleInitialized();
    }

    /// @notice call Safe via executeTransactionFromModule
    /// @dev bypasses any access restriction of reaching threshold signatures
    /// @param to address where the Safe should make a call or interact
    /// @param value amount of ETH to be sent
    /// @param data encoded data to be used when interacting with `to`
    /// @param operation type of operation to interact with `to`
    function _execute(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation
    ) internal {
        bool isSuccess = _safe.execTransactionFromModule(
            to,
            value,
            data,
            operation
        );
        if (!isSuccess) {
            revert ModuleExecutionFailed();
        }
    }

    /// @notice Set new Safe instance
    /// @dev add access restriction to set new safe in child contract
    /// @param _newSafe new safe instance (address)
    function _setNewSafe(Safe _newSafe) internal {
        ContractChecker.checkIsContarct(address(_newSafe));
        Safe prevSafe = _safe;
        _safe = _newSafe;
        emit TargetSafeUpdated(prevSafe, _newSafe);
    }

    /// @notice get target safe instance (address)
    /// @return safe target safe instance (address)
    function _getSafe() internal view returns(Safe safe) {
        return _safe;
    }
}
