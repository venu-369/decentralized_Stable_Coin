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
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
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

contract DSCEngine is ReentrancyGuard {
    /////////////////
    // Errors //
    ///////////////
    error DSCEngine__NeedsMoreThanZero();
    error DSCENgine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__NotAllowed();

    error DSCEngine__TransferFailed();

    /////////////////////
    // State Variables //
    ///////////////////
    mapping(address token => address priceFeed) private s_priceFeeds; //tokenToPriceFeed
    mapping(address user => mapping(address token => uint256 amount)) private s_CollateralDeposited; //userToTokenToCollateral

    DecentralizedStableCoin private immutable i_dsc;

    ///////////
    // Events //
    ////////////
    event CollateralDeposited(address indexed user, uint256 indexed amount, address indexed token);

    /////////////////
    // Modifiers //
    ///////////////
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowed();
        }
        _;
    }

    /////////////////
    // Functions //
    ///////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        //USD price Feeds
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCENgine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }
        // For example ETH/USD, BTC/USD, etc
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    ////////////////////////
    // External Functions //
    ///////////////////////
    function depositCollateralAndMintDsc() external {}

    /*
    * @notice follows CEI
    * @param tokenCollateralAddress the address of the token to deposit as collateral
    * @param amountCollateral the amount of collateral to deposit
    */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_CollateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, amountCollateral, tokenCollateralAddress);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function brnDsc() external {}

    function liquidate() external {}

    function healthFactor() external view {}
}
