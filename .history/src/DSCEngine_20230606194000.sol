//SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
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
import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
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
    /////////////////
    // Errors //
    ///////////////
    error DSCEngine__NeedsMoreThanZero();
    error DSCENgine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();

    /////////////////////
    // State Variables //
    ///////////////////
    mapping(address token => address priceFeed) private s_priceFeeds; //tokenToPriceFeed

    DecentralizedStableCoin private immutable i_dsc;

    /////////////////
    // Modifiers //
    ///////////////
    modifier moreThanZero(uint256 amount) {
        if(amount == 0){
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    //modifier isAllowedToken(address token){}

    /////////////////
    // Functions //
    ///////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        //USD price Feeds
        if(tokenAddresses.length != priceFeedAddresses.length){
            revert DSCENgine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }
        // For example ETH/USD, BTC/USD, etc
        for(uint256 i = 0; i < tokenAddresses.length; i++){
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }


    ////////////////////////
    // External Functions //
    ///////////////////////
    function depositCollateralAndMintDsc() external {}

    /*
    * @param tokenCollateralAddress the address of the token to deposit as collateral
    * @param amountCollateral the amount of collateral to deposit
    */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
     external moreThanZero(amountCollateral) {


    }

    function redeemCollateralForDsc() external {}
    
    function redeemCollateral() external {}

    function mintDsc(  ) external {}

    function brnDsc() external {}

    function liquidate() external {

    }

    function healthFactor() external view {

    }

}