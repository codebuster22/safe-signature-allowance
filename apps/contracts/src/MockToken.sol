// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Mock Token
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice A test ERC20 token that mints 100 million on demand
/// @dev not to be used in production
contract MockToken is ERC20 {
    uint256 public constant HUNDRED_MILLION = 100_000_000;

    constructor() ERC20("Mock Token", "MT") {}

    function mint(address _receiver) public {
        _mint(_receiver, HUNDRED_MILLION);
    }
}
