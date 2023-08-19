/// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

abstract contract SignatureAllowanceStorage {
    // mapping to track which salt have been executed
    // using mapping to allow non-sequential claims
    // salt to prevent replay attacks
    mapping(uint256 => bool) public saltUsed;
    mapping(address => bool) public tokensAllowed;

    address public defaultToken;

    uint256 public expiryPeriod;

    /// @notice used to prevent storage slot collision
    /// @dev Gap of 50 storage slots to allow adding new state variables in next upgrades
    uint256[50] private __gap;
}