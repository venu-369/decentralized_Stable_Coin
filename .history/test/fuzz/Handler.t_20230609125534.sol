//SPDX License-Identifier: MIT

//handler is goin to narrow down the way we call function

pragma solidity ^0.8.18;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/decentralizedStableCoin.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc) {
        dsce = _dscEngine;
        dsc = _dsc;
    }

    //redeem collateral

    function depositCollateral(address collateral, uint256 amountCollateral) public {
        dsce.depositCollateral(collateral, amountCollateral);
    }
}
