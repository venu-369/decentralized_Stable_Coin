//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/decentralizedStableCoin.sol";

contract DeployDSC is Script {
    function run() external returns (DecentralizedStableCoin, DSCEngine) {}
}
