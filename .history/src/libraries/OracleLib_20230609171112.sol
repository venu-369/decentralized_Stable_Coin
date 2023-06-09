//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "../interfaces/AggregatorV3Interface.sol";

/**
 * @title OracleLib
 * @author Venu Gopal Miriyala
 * @notice This library is used to check the chainLink Oracle for stale data.
 * If a price is stale, the function will revert, and render the DSCEngine unusable - this is by design.
 * 
 * We want the DSCEngine to freeze if prices become stale.
 * 
 * So if the chainlink network explodes and you have a lot of money locked in the protocol..
 */

library oracleLib {
    function stalePricecheck()
}