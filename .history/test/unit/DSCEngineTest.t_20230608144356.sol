//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "/Users/venugopalmiriyala/Desktop/coin_stable/lib/forge-std/src/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DecentralizedStableCoin} from "../../src/decentralizedStableCoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";

contract DSCEngineTest is Test {
    DeployDSC _deployer;
    DecentralizedStableCoin _dsc;
    DSCEngine _dsce;

    function setUp() public {
        _deployer = new DeployDSC();
        (_dsc, _dsce) = _deployer.run();
    }
}
