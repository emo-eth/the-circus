// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {SpecificIntent, CHECK_DEPLOYED} from "./helpers/SpecificIntent.sol";
import {TheCircusZone, ZoneInterface} from "../src/TheCircusZone.sol";
import {ZoneParameters} from "seaport-types/lib/ConsiderationStructs.sol";
import {ArbitraryIntentData} from "../src/Structs.sol";

contract TheCircusZoneTest is Test {
    TheCircusZone test;
    address constant CREATE2_ADDRESS = 0x67385EF0f630d767Db1197AEd245F2E566A372Cb;

    function setUp() public {
        test = new TheCircusZone();
    }

    function testValidateOrderSuccess() public {
        ZoneParameters memory params;
        params.zoneHash = bytes32(uint256(uint160(CREATE2_ADDRESS)));
        ArbitraryIntentData memory data =
            ArbitraryIntentData({initData: type(SpecificIntent).creationCode, salt: bytes32(uint256(1))});
        params.extraData = abi.encode(data);
        vm.etch(CHECK_DEPLOYED, "deployed");
        bytes4 magicValue = test.validateOrder(params);
        assertEq(magicValue, ZoneInterface.validateOrder.selector);
    }

    function testValidateOrderConstructorRevert() public {
        ZoneParameters memory params;
        params.zoneHash = bytes32(uint256(uint160(CREATE2_ADDRESS)));
        ArbitraryIntentData memory data =
            ArbitraryIntentData({initData: type(SpecificIntent).creationCode, salt: bytes32(uint256(1))});
        params.extraData = abi.encode(data);
        vm.expectRevert(SpecificIntent.NotDeployed.selector);
        test.validateOrder(params);
    }

    function testValidateOrderInvalidZoneHash() public {
        ZoneParameters memory params;
        params.zoneHash = bytes32(uint256(uint160(CREATE2_ADDRESS)));
        ArbitraryIntentData memory data = ArbitraryIntentData({initData: type(SpecificIntent).creationCode, salt: 0});
        params.extraData = abi.encode(data);
        vm.etch(CHECK_DEPLOYED, "deployed");
        vm.expectRevert(TheCircusZone.InvalidExtraData.selector);
        test.validateOrder(params);
    }
}
