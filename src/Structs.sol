// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct ArbitraryIntentData {
    /**
     * @dev the initData for a "smart contract" intended to make all assertions in its constructor, else revert
     */
    bytes initData;
    /**
     * @dev the create2 salt for the "smart contract" so that the address can be used as the zoneHash, and identical
     *      initCode can be used in the same transaction (by specifying different salts)
     */
    bytes32 salt;
}
