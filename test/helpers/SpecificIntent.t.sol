// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {SpecificIntent, CHECK_DEPLOYED} from "./SpecificIntent.sol";

contract SpecificIntentTest is Test {
    function testDeploySuccess() public {
        vm.etch(CHECK_DEPLOYED, "deployed");
        SpecificIntent intent = new SpecificIntent();
        assertEq(address(intent).code.length, 0, "should not have deployed code");
    }

    function testDeployedCheckFailure() public {
        vm.expectRevert(SpecificIntent.NotDeployed.selector);
        new SpecificIntent();
    }
}
