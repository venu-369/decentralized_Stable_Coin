//SPDX-License-Identifier: MIT

// have our invariants / our properties

//what are our invariants?

// 1. The total supply of DSC should be less than the total value of collateral
// 2. getter view functions should never revert <- evergreen invariant

pragma solidity ^0.8.18;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {StdInvariant} from "../../lib/forge-std/src/StdInvariant.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/decentralizedStableCoin.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract OpenInvariantsTest is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        targetContract(address(dsce));
    }
}
