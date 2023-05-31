// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ArbitraryIntent} from "../../src/ArbitraryIntent.sol";

address constant CHECK_DEPLOYED = address(uint160(uint256(keccak256("CHECK_DEPLOYED"))));

contract SpecificIntent is ArbitraryIntent {
    error NotDeployed();

    function expressIntent() internal view override {
        if (CHECK_DEPLOYED.code.length == 0) {
            revert NotDeployed();
        }
    }
}
