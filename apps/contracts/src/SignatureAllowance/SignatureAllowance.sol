/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {SafeModule, Enum, Initializable, Safe} from "../SafeModule/SafeModule.sol";
import {SignatureAllowanceStorage} from "./SignatureAllowanceStorage.sol";
import {ISignatureAllowance} from "../interfaces/ISignatureAllowance.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title Signature Allowance
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice A Safe module implementation to allow safe signers to dynamically generate allowance for non-signers
/// @dev to be deployed as UUPS proxy
contract SignatureAllowance is
    SafeModule,
    OwnableUpgradeable,
    PausableUpgradeable,
    UUPSUpgradeable,
    ISignatureAllowance,
    SignatureAllowanceStorage
{
    /// When a user tries to withdraw tokens using same salt again
    /// prevents replay attack
    error SaltAlreadyUsed(uint256 salt);

    /// When a signer tries to add a token to allowlist
    /// but the token is already allowlisted
    error TokenAlreadyInAllowlist();

    /// When a signer tries to remove a token from allowlist
    /// but the token is not allowlisted
    error TokenNotInAllowlist();

    /// When a user tries to use a signature
    /// but the signature is expired
    error SignatureInactive();

    /// @notice Logs when a token is added to allowlist
    /// @dev Use this to index any new token added to allowlist
    /// @param newToken new token address added to allowlist
    event TokenAllowlistAppended(address newToken);

    /// @notice Logs when a token is removed from the allowlist
    /// @dev Use this to index any token that is removed from allowlist
    /// @param removedToken address of token remvoed from allowlist
    event TokenRemovedFromAllowlist(address removedToken);

    /// @notice Logs when expiry period is updated
    /// @dev Use this to index when the expiry period is updated
    /// @param newExpiryPeriod new expiry period (in seconds)
    event ExpiryPeriodUpdated(uint256 newExpiryPeriod);

    /// @notice Logs when default token is updated
    /// @dev Use this to index when default token is updated
    /// @param newDefaultToken address of new default token
    event DefaultTokenUpdated(address newDefaultToken);

    /// @notice inspired from SAFE_TX_TYPEHASH
    bytes32 private constant SIGNAURE_ALLOWANCE_TX_TYPEHASH =
        keccak256(
            "SignatureAllowance(address to,uint256 value,bytes data,uint8 operation,uint256 creationTime,uint256 salt)"
        );

    /// @notice initializer
    /// @dev initializes SignatureAllowance contract. Use this instead of constructor to support proxy
    /// @param _safe target safe instance (address)
    /// @param _defaultToken token to be added to allowlist and set as default token
    /// @param _expiryPeriod expiry period
    function initialize(
        Safe _safe,
        address _defaultToken,
        uint256 _expiryPeriod
    ) external initializer {
        // initialize safe module
        __SafeModule_init(_safe);

        // initialize ownable
        __Ownable_init();
        // transfer ownership to safe
        _transferOwnership(address(_safe));

        // initialize pausable
        __Pausable_init();

        // initialize UUPS
        __UUPSUpgradeable_init();

        // add token to allowlist and set as default token
        _setNewDefaultToken(_defaultToken);

        // set expiry period
        expiryPeriod = _expiryPeriod;

        // ensure default salt value (0) is used by default
        // to prevent unknown errors due to default values
        saltUsed[0] = true;
    }

    /// @inheritdoc	ISignatureAllowance
    function withdrawAllowanceDefaultToken(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        uint256 _creationTime,
        uint256 _salt
    ) external whenNotPaused {
        withdrawAllowanceFromToken(
            _amount,
            _withdrawer,
            _signatures,
            defaultToken,
            _creationTime,
            _salt
        );
    }

    /// @inheritdoc	ISignatureAllowance
    function withdrawAllowanceFromToken(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        address _token,
        uint256 _creationTime,
        uint256 _salt
    ) public whenNotPaused {
        // ensure the salt is not used earlier
        // prevent replay attack
        if (saltUsed[_salt]) {
            revert SaltAlreadyUsed(_salt);
        }
        // check if the signature(s) is valid and active
        isSignatureValid(
            _amount,
            _withdrawer,
            _signatures,
            _token,
            _creationTime,
            _salt
        );

        // mark salt used
        saltUsed[_salt] = true;

        // generate data to transfer tokens from Safe to withdrawer
        // when interacting with `token`, msg.sender will be Safe
        bytes memory data = abi.encodeWithSelector(
            ERC20Upgradeable.transfer.selector,
            _withdrawer,
            _amount
        );

        // execute
        _execute(_token, 0, data, Enum.Operation.Call);
    }

    /// @inheritdoc	ISignatureAllowance
    function addTokenToAllowlist(address _newToken) external onlyOwner {
        // if token is allowlisted, revert
        if (tokensAllowed[_newToken]) {
            revert TokenAlreadyInAllowlist();
        }
        tokensAllowed[_newToken] = true;
        emit TokenAllowlistAppended(_newToken);
    }

    /// @inheritdoc	ISignatureAllowance
    function removeTokenFromAllowlist(address _token) external onlyOwner {
        // if token is not allowlisted, revert
        if (!tokensAllowed[_token]) {
            revert TokenNotInAllowlist();
        }
        tokensAllowed[_token] = false;
        emit TokenRemovedFromAllowlist(_token);
    }

    /// @inheritdoc	ISignatureAllowance
    function setNewSafe(Safe _newSafe) external onlyOwner {
        _setNewSafe(_newSafe);
    }

    /// @inheritdoc	ISignatureAllowance
    function setNewDefaultToken(address _newDefaultToken) external onlyOwner {
        _setNewDefaultToken(_newDefaultToken);
    }

    /// @notice Set new Default Token address and add to allowlist if not allowed
    /// @dev If a default token is not allowlisted then add the new default token to allowlist
    /// @param _newDefaultToken new default token address
    function _setNewDefaultToken(address _newDefaultToken) internal {
        // if token is not allowlisted, add token to allowlist
        if (!tokensAllowed[_newDefaultToken]) {
            tokensAllowed[_newDefaultToken] = true;
            emit TokenAllowlistAppended(_newDefaultToken);
        }
        // set token as default token
        defaultToken = _newDefaultToken;
        emit DefaultTokenUpdated(_newDefaultToken);
    }

    /// @inheritdoc	ISignatureAllowance
    function getSafe() external view returns (Safe _safe) {
        return _getSafe();
    }

    /// @inheritdoc	ISignatureAllowance
    function getDefaultToken() external view returns (address _defaultToken) {
        return defaultToken;
    }

    /// @inheritdoc	ISignatureAllowance
    function checkTokenAllowlisted(
        address _token
    ) external view returns (bool _isAllowlisted) {
        return tokensAllowed[_token];
    }

    /// @inheritdoc	ISignatureAllowance
    function isSignatureValid(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        address _token,
        uint256 _creationTime,
        uint256 _salt
    ) public view returns (bool _isValid) {
        // generate data to transfer tokens from Safe to withdrawer
        bytes memory data = abi.encodeWithSelector(
            ERC20Upgradeable.transfer.selector,
            _withdrawer,
            _amount
        );

        // check if signature is active
        if (block.timestamp - _creationTime > expiryPeriod) {
            revert SignatureInactive();
        }

        // check if signature is valid
        _checkSignaturesValidity(
            _token,
            0,
            data,
            Enum.Operation.Call,
            _creationTime,
            _salt,
            _signatures
        );

        // if signature is not valid, the call will revert
        // so we can safely consider if nothing fail till here
        // the signature is valid
        return true;
    }

    /// @inheritdoc	ISignatureAllowance
    function getSignatureExpiryPeriod()
        external
        view
        returns (uint256 _expiryPeriod)
    {
        return expiryPeriod;
    }

    /// @inheritdoc	ISignatureAllowance
    function setSignatureExpiryPeriod(
        uint256 _newExpiryPeriod
    ) external onlyOwner {
        expiryPeriod = _newExpiryPeriod;
        emit ExpiryPeriodUpdated(_newExpiryPeriod);
    }

    /// @inheritdoc	ISignatureAllowance
    function encodeTransactionData(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 creationTime,
        uint256 _salt
    ) public view returns (bytes memory hashData) {
        // get safe instance
        Safe safe = _getSafe();

        // generate hash
        bytes32 signatureAllowanceTxHash = keccak256(
            abi.encode(
                SIGNAURE_ALLOWANCE_TX_TYPEHASH,
                to,
                value,
                keccak256(data),
                operation,
                creationTime,
                _salt
            )
        );
        return
            abi.encodePacked(
                bytes1(0x19),
                bytes1(0x01),
                safe.domainSeparator(),
                signatureAllowanceTxHash
            );
    }

    /// @notice check signatures reaches threshold on Safe
    /// @dev reverts if signature is invalid | returns true if valid
    /// @param to target contract to be interacted with by Safe
    /// @param value amount of ETH to be sent
    /// @param data encoded data to interact with `to`
    /// @param operation type of interaction operation
    /// @param creationTime timestamp when the signature was created
    /// @param salt a unique salt used to generate signature
    /// @param sigantures conactendated strings of X signatures, where X is >= threshold signers
    /// @return reverts if invalid else returns true
    function _checkSignaturesValidity(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 creationTime,
        uint256 salt,
        bytes memory sigantures
    ) internal view returns (bool) {
        Safe safe = _getSafe();
        bytes memory txHashData = encodeTransactionData(
            to,
            value,
            data,
            operation,
            creationTime,
            salt
        );
        // Increase nonce and execute transaction.
        bytes32 txHash = keccak256(txHashData);
        // if signature is invalid, checkSignatures will revert
        safe.checkSignatures(txHash, txHashData, sigantures);
        // if checkSignatures didn't revert that means, signature is valid
        return true;
    }

    function pause() external whenNotPaused onlyOwner {
        _pause();
    }

    function unpause() external whenPaused onlyOwner {
        _unpause();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual onlyOwner override {}
}
