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

/*
@title Decentralized Stable Coin Engine 
@author Venu Gopal Miriyala
* The system is designd to be as minimal as possible, and have the token maintain a 1 token == 1$ peg.
* This stablecoin has the properties:
* - Exogenous Collateral
* - Dollar Pegged
* - Algorithmically Stable
*
* It is similar to DAI if DAI had no governanve, no fees, and was only backed by ETH and WBTC
*
* Our DSC systme should always be over collaterized. At no poiint should the value of all collateral <= the $ backed value if the dsc.
* @notice This contract is the core of the DSC System. It handles all the logic for mining and redeeming DSC, as well as depositing & withdrawing Collateral.
*
*@notice this contract is very loosely based on the mAkerDAO DSS (DAI) system.
*/

contract DSCEngine {
    function depositCollateralAndMintDsc() external {}

    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral) external {}

    function redeemCollateralForDsc() external {}
    
    function redeemCollateral() external {}

    function mintDsc(  ) external {}

    function brnDsc() external {}

    function liquidate() external {

    }

    function healthFactor() external view {

    }

}