//SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// type declarations
// state variables
// events
// Modifiers
// functions

// Layout of Functions:
// constructor
// recieve function (if exists)
// fallback function (if exists)
// external
// public
// interval
// private
// view and pure functions

pragma solidity ^0.8.18;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/*
@title Decentralized Stable Coin
@author Venu Gopal Miriyala
Collateral: Exogenous(ETH, BTC)
Minting: Algorithmic
Relative Stability: pegged to USD

This is a contract meant to be governed by DSCEngine. this contact is just the ERC20 implementation of our syablecoinsystem.
*/
contract DecentralizedStableCoin {
    constructor(){

    }
}