//SPDX-License-Identifier: MIT

// have our invariants / our properties

//what are our invariants?

// 1. The total supply of DSC should be less than the total value of collateral
// 2. getter view functions should never revert <- evergreen invariant

pragma solidity ^0.8.18;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {StdInvariant} from "../../lib/forge-std/src/StdInvariant.sol";

contract invariantsTest {}
