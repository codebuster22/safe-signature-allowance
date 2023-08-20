// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title GM Token
/// @author Mihirsinh Parmar <mihirsinh.parmar.it@gmail.com>
/// @notice A test ERC20 token that mints 100 million tokens to receiver
/// @dev not to be used in production
contract GM is ERC20 {
    uint256 public constant HUNDRED_MILLION = 100_000_000 ether;

    constructor(address _receiver) ERC20("GM", "GM") {
        _mint(_receiver, HUNDRED_MILLION);
    }
}
