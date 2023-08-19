/// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Safe, Enum} from "@safe-global/safe-contracts/contracts/Safe.sol";

/// @title Signature Allowance interface
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice outlines all the functions to be implemented by Signature Allowance contract
interface ISignatureAllowance {
    /// @notice Withdraws allowance for default token
    /// @dev uses withdrawAllowanceFromToken underneath, by passing token address as default token address
    /// @param _amount amount of tokens to be withdrawn
    /// @param _withdrawer address of withdrawer
    /// @param _signatures concatendated signature string of atleast X safe signers where X is threshold signers
    function withdrawAllowanceDefaultToken(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        uint256 _creationTime,
        uint256 _salt
    ) external;

    /// @notice Withdraws allownace for specified token
    /// @dev checks signature and trafers token from Safe to withdrawer
    /// @param _amount amount of tokens to be withdrawn
    /// @param _withdrawer address of withdrawer
    /// @param _signatures concatendated signature string of atleast X safe signers where X is threshold signers
    /// @param _token address of token to be withdrawn
    function withdrawAllowanceFromToken(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        address _token,
        uint256 _creationTime,
        uint256 _salt
    ) external;

    /// @notice Adds new token to allowlist
    /// @dev updates mapping for token and set it to true
    /// @param _newToken address of token to be added
    function addTokenToAllowlist(address _newToken) external;

    /// @notice removed token from allowlist
    /// @dev updates mapping for tokens and set it to false
    /// @param _token address of token to be removed from allowlist
    function removeTokenFromAllowlist(address _token) external;

    /// @notice Set new Safe address to withdraw tokens from
    /// @dev Ensure to enable this module in Safe, else all withdrawals will fail
    /// @param _newSafe address of new Safe
    function setNewSafe(Safe _newSafe) external;

    /// @notice Set new Default Token address and add to allowlist if not allowed
    /// @dev If a default token is not allowlisted then add the new default token to allowlist
    /// @param _newDefaultToken new default token address
    function setNewDefaultToken(address _newDefaultToken) external;

    /// @notice get Safe address
    /// @dev Tokens are withdrawn from this safe
    /// @return _safe safe address
    function getSafe() view external returns(Safe _safe);

    /// @notice get default token to be withdrawn
    /// @dev default token is withdrawn when use calls withdrawAllowanceDefaultToken
    /// @return _defaultToken address of default token
    function getDefaultToken() view external returns(address _defaultToken) ;

    /// @notice check is a token is allowed to be withdrawn
    /// @param _token address of token to be checked
    /// @return _isAllowlisted a bool representing if token is allowlisted, true - allowlisted, 
    function checkTokenAllowlisted(address _token) view external returns(bool _isAllowlisted);

    /// @notice check if a signature is valid and active
    /// @dev uses Safe.checkSignatures function by generating datahash and ensuring the signature is still active
    /// @param _amount amount of tokens to be withdrawn
    /// @param _withdrawer address of withdrawer
    /// @param _signatures concatendated signature string of atleast X safe signers where X is threshold signers
    /// @param _token address of token to be withdrawn
    /// @return _isValid a bool value representing if a token is allowlisted or not
    function isSignatureValid(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        address _token,
        uint256 _creationTime,
        uint256 _salt
    ) view external returns(bool _isValid);

    /// @notice get expiry time period after which a signature becomes inactive
    /// @dev for signature to be active expiryPeriod + creationTime <= block.timestamp
    /// @return _expiryPeriod expiry period (in seconds) after which a signature is inactive. SignatureCreationTime - now() < expiryPeriod
    function getSignatureExpiryPeriod() view external returns(uint256 _expiryPeriod);

    /// @notice set new expiry period (in seconds)
    /// @dev for signature to be active expiryPeriod + creationTime <= block.timestamp
    /// @param _newExpiryPeriod expiry period (in seconds) after which a signature is inactive. SignatureCreationTime - now() < expiryPeriod
    function setSignatureExpiryPeriod(uint256 _newExpiryPeriod) external;

    /// @notice custom encoding of transaction data
    /// @dev a custom adaptation from Safe contracts
    /// @param to target contract to be interacted with by Safe
    /// @param value amount of ETH to be sent
    /// @param data encoded data to interact with `to`
    /// @param operation type of interaction operation
    /// @param creationTime timestamp when the signature was created
    /// @param _salt a unique salt used to generate signature
    /// @return hashData encoded hashed data to be used in generating signature process
    function encodeTransactionData(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 creationTime,
        uint256 _salt
    ) view external returns(bytes memory hashData);
}