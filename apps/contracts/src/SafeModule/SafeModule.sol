/// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {ModuleManager} from "@safe-global/safe-contracts/contracts/base/ModuleManager.sol";
import {Safe, Enum} from "@safe-global/safe-contracts/contracts/Safe.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

library ContractChecker {
    error NotAContract(address invalidContract);

    bytes32 private constant ACCOUNT_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

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

abstract contract SafeModule is Initializable {
    // events
    event SafeModuleInitialized();
    event TargetSafeUpdated(Safe prevSafe, Safe newSafe);

    // errors
    error ModuleExecutionFailed();

    // Safe contract instance
    Safe private _safe;

    // initialize module and check if module is enabled
    function __SafeModule_init(Safe _newSafe) internal onlyInitializing {
        _setNewSafe(_newSafe);
        emit SafeModuleInitialized();
    }

    // execute transaction from module via safe (execTransactionFromModule)
    function _execute(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        Safe safe
    ) internal {
        bool isSuccess = safe.execTransactionFromModule(
            to,
            value,
            data,
            operation
        );
        if (!isSuccess) {
            revert ModuleExecutionFailed();
        }
    }

    // set new safe
    function _setNewSafe(Safe _newSafe) internal {
        ContractChecker.checkIsContarct(address(_newSafe));
        Safe prevSafe = _safe;
        _safe = _newSafe;
        emit TargetSafeUpdated(prevSafe, _newSafe);
    }

    // get safe address
    function _getSafe() internal view returns(Safe safe) {
        return _safe;
    }
}
