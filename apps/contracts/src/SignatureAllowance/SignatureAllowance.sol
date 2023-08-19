/// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {SafeModule, Enum, Initializable, Safe} from "../SafeModule/SafeModule.sol";
import {SignatureAllowanceStorage} from "./SignatureAllowanceStorage.sol";
import {ISignatureAllowance} from "../interfaces/ISignatureAllowance.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract SignatureAllowance is
    SafeModule,
    SignatureAllowanceStorage,
    ISignatureAllowance
{
    error SaltAlreadyUsed(uint256 salt);
    error TokenAlreadyInAllowlist();
    error TokenNotInAllowlist();
    error SignatureInactive();

    event TokenAllowlistAppended(address newToken);
    event TokenRemovedFromAllowlist(address removedToken);
    event ExpiryPeriodUpdated(uint256 newExpiryPeriod);
    event DefaultTokenUpdated(address newDefaultToken);

    bytes32 private constant SIGNAURE_ALLOWANCE_TX_TYPEHASH =
        keccak256(
            "SignatureAllowance(address to,uint256 value,bytes data,uint8 operation,uint256 creationTime,uint256 salt)"
        );

    // initialize
    function initialize(
        Safe _safe,
        address _defaultToken,
        uint256 _expiryPeriod
    ) external initializer {
        __SafeModule_init(_safe);
        _setNewDefaultToken(_defaultToken);
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
    ) external {
        withdrawAllowanceFromToken(_amount, _withdrawer, _signatures, defaultToken, _creationTime, _salt);
    }

    /// @inheritdoc	ISignatureAllowance
    function withdrawAllowanceFromToken(
        uint256 _amount,
        address _withdrawer,
        bytes calldata _signatures,
        address _token,
        uint256 _creationTime,
        uint256 _salt
    ) public {
        Safe safe = _getSafe();
        // checks
        if(saltUsed[_salt]) {
            revert SaltAlreadyUsed(_salt);
        }
        isSignatureValid(_amount, _withdrawer, _signatures, _token, _creationTime, _salt);

        // mark salt used
        saltUsed[_salt] = true;

        // generate data
        bytes memory data = abi.encodeWithSelector(
            ERC20Upgradeable.transfer.selector,
            _withdrawer,
            _amount
        );

        // execute
        _execute(_token, 0, data, Enum.Operation.Call);
    }

    /// @inheritdoc	ISignatureAllowance
    function addTokenToAllowlist(address _newToken) external {
        if (tokensAllowed[_newToken]) {
            revert TokenAlreadyInAllowlist();
        }
        tokensAllowed[_newToken] = true;
        emit TokenAllowlistAppended(_newToken);
    }

    /// @inheritdoc	ISignatureAllowance
    function removeTokenFromAllowlist(address _token) external {
        if (!tokensAllowed[_token]) {
            revert TokenNotInAllowlist();
        }
        tokensAllowed[_token] = false;
        emit TokenRemovedFromAllowlist(_token);
    }

    /// @inheritdoc	ISignatureAllowance
    function setNewSafe(Safe _newSafe) external {
        _setNewSafe(_newSafe);
    }

    /// @inheritdoc	ISignatureAllowance
    function setNewDefaultToken(address _newDefaultToken) external {
        _setNewDefaultToken(_newDefaultToken);
    }

    /// @notice Set new Default Token address and add to allowlist if not allowed
    /// @dev If a default token is not allowlisted then add the new default token to allowlist
    /// @param _newDefaultToken new default token address
    function _setNewDefaultToken(address _newDefaultToken) internal {
        if (!tokensAllowed[_newDefaultToken]) {
            tokensAllowed[_newDefaultToken] = true;
            emit TokenAllowlistAppended(_newDefaultToken);
        }
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
        // create params
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
        // use creation time in signature's hash
        _checkSignaturesValidity(
            _token,
            0,
            data,
            Enum.Operation.Call,
            _creationTime,
            _salt,
            _signatures
        );
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
    function setSignatureExpiryPeriod(uint256 _newExpiryPeriod) external {
        expiryPeriod = _newExpiryPeriod;
        emit ExpiryPeriodUpdated(_newExpiryPeriod);
    }

    // check signatures reaches threshold on Safe
    // reverts if signature is invalid
    // returns true if valid
    function _checkSignaturesValidity(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 _creationTime,
        uint256 salt,
        bytes memory _sigantures
    ) internal view returns (bool) {
        Safe safe = _getSafe();
        bytes memory txHashData = encodeTransactionData(
            to,
            value,
            data,
            operation,
            _creationTime,
            salt
        );
        // Increase nonce and execute transaction.
        bytes32 txHash = keccak256(txHashData);
        // if signature is invalid, checkSignatures will revert
        safe.checkSignatures(txHash, txHashData, _sigantures);
        // if checkSignatures didn't revert that means, signature is valid
        return true;
    }

    function encodeTransactionData(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 creationTime,
        uint256 _salt
    ) view public returns(bytes memory hashData) {
        Safe safe = _getSafe();
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
}
