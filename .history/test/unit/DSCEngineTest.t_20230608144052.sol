//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "/Users/venugopalmiriyala/Desktop/coin_stable/lib/forge-std/src/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";

contract DSCENtinetest is Test {
    DeployDSC deployer;

    function setUp() public {
        deployer = new DeployDSC();
    }
}
