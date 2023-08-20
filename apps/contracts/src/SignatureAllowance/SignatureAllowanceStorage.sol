/// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/// @title Signature Allowance Storage
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice Storage contract for Signature Allowance
abstract contract SignatureAllowanceStorage {
    /// @notice address of default token that can be withdrawn
    /// @dev default token will alway be allowlisted and needs to be mapped in tokensAllowed mapping
    /// @return defaultToken default token that can be withdrawn
    address public defaultToken;

    /// @notice period from creation time till the signature will remain active
    /// @dev signatures are only active between this period. expiryPeriod = expiryTime - creationTime
    /// @return expiry period (in seconds)
    uint256 public expiryPeriod;

    /// @notice mapping to track which salt have been executed
    /// @dev using mapping to allow non-sequential claims
    ///      salt to prevent replay attack.
    /// @return if the salt has been used or not
    mapping(uint256 => bool) public saltUsed;

    /// @notice mapping to track tokens that are allowlisted to be withdrawn by withdrawer
    /// @dev future: can use linked list and bitmap to see if a token is allowlisted
    /// @return if a token is allowlisted to be withdrawn
    mapping(address => bool) public tokensAllowed;

    /// @notice used to prevent storage slot collision
    /// @dev Gap of 50 storage slots to allow adding new state variables in next upgrades
    uint256[50] private __gap;
}
