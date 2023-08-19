// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GM is ERC20 {
    uint256 constant public HUNDRED_MILLION = 100_000_000 ether;

    constructor (address _receiver) ERC20("GM", "GM") {
        _mint(_receiver, HUNDRED_MILLION);
    }
}
