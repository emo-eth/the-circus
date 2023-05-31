// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {SpecificIntent, CHECK_DEPLOYED} from "./helpers/SpecificIntent.sol";

contract ArbitraryIntentTest is Test {
    function testLeaveNoTrace() public {
        vm.etch(CHECK_DEPLOYED, "deployed");
        SpecificIntent intent = new SpecificIntent();
        assertEq(address(intent).code.length, 0, "should not have deployed code");
    }
}
