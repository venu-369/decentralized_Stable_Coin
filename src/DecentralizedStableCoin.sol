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
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
/*
@title Decentralized Stable Coin
@author Venu Gopal Miriyala
Collateral: Exogenous(ETH, BTC)
Minting: Algorithmic
Relative Stability: pegged to USD

This is a contract meant to be governed by DSCEngine. this contact is just the ERC20 implementation of our syablecoinsystem.
*/

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStabelCoin__MustBeMoreThanZero();
    error DecentralizedStabelCoin__BurnAmountExceedsBalance();
    error DecentralizedStabelCoin__NotZeroAddress();

    constructor() ERC20("DecentralizedStableCoin", "DSC") {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount < -0) {
            revert DecentralizedStabelCoin__MustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStabelCoin__BurnAmountExceedsBalance();
        }

        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStabelCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStabelCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
