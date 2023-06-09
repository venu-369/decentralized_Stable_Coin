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
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
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
    error DSCEngine__BreaksHealthFactor(uint256 healthFactor);
    error DSCEngine__MintFailed();

    /////////////////////
    // State Variables //
    ///////////////////
    uint256 private constant ADDITION_FEED_PRECISION = 1e10;
    uint256 private constant PRECISION = 1e18;
    uint256 private constant LIQUIDATION_THRESHOLD = 50; // 200% over collateralized
    uint256 private constant LIQUIDATION_PRECISION = 100;
    uint256 private constant MIN_HEALTH_FACTOR = 1;

    mapping(address token => address priceFeed) private s_priceFeeds; //tokenToPriceFeed
    mapping(address user => mapping(address token => uint256 amount)) private s_CollateralDeposited; //userToTokenToCollateral
    mapping(address user => uint256 amountDscMinted) private s_DscMinted; //userToDscMinted

    address[] private s_CollateralTokens;

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
            s_CollateralTokens.push(tokenAddresses[i]);
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

    //1. Check i fthe collateral value > DSC amount. Price feeds, values,etc
    /*
    *@notice follows CEI
    *@param amountDscToMint the amount of DSC to mint
    *@notice They must have more collateral value than min threshold
    */
    function mintDsc(uint256 amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DscMinted[msg.sender] += amountDscToMint;
        // if they minted too much
        _revertIfHealthFactorIsBroken(msg.sender);
        bool minted = i_dsc.mint(msg.sender, amountDscToMint);
        if (!minted) {
            revert DSCEngine__MintFailed();
        }
    }

    function brnDsc() external {}

    function liquidate() external {}

    function healthFactor() external view {}

    ///////////////////////////////////
    // Private and Internal View Functions //
    ///////////////////////////////////

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DscMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    /*returns how close to liquidation a user is
    * If a user goes below 1, then they can get liquidated
    */
    function _healthFactor(address user) private view returns (uint256) {
        //total DSC minted
        // total collateral VALUE.
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
        uint256 collateralAdjustedForThreshold = (collateralValueInUsd * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION;
        return (collateralAdjustedForThreshold * PRECISION) / totalDscMinted;
        // return (collateralValueInUsd / totalDscMinted);
    }

    //1. Check health factor
    //2. Revert if thery dont
    function _revertIfHealthFactorIsBroken(address user) internal view {
        uint256 userHealthFactor = _healthFactor(user);
        if (userHealthFactor < MIN_HEALTH_FACTOR) {
            revert DSCEngine__BreaksHealthFactor(userHealthFactor);
        }
    }

    ///////////////////////////////////
    // Public and External View Functions //
    ///////////////////////////////////
    function getAccountCollateralValue(address user) public view returns (uint256 totalCollateralValueInUsd) {
        //loop through each collateral token, get the amount they have deposited, and map it to the price,to get the USD value
        for (uint256 i = 0; i < s_CollateralTokens.length; i++) {
            address token = s_CollateralTokens[i];
            uint256 amount = s_CollateralDeposited[user][token];

            totalCollateralValueInUsd += getUsdValue(token, amount);
        }
        return totalCollateralValueInUsd;
    }

    function getUsdValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[token]);
        (, int256 price,,,) = priceFeed.latestRoundData();
        //1 ETH = $1000
        //the returned value from CL will be 1000 * 1e8
        return ((uint256(price) * ADDITION_FEED_PRECISION) * amount) / PRECISION; // (1000 * 1e8) * 1000 * 1e8
    }
}
