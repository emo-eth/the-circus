// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ZoneInterface} from "seaport-types/interfaces/ZoneInterface.sol";
import {ZoneParameters, Schema} from "seaport-types/lib/ConsiderationStructs.sol";
import {ArbitraryIntentData} from "./Structs.sol";

contract TheCircusZone is ZoneInterface {
    error InvalidExtraData();

    /**
     * @dev Validates an order.
     *
     * @param zoneParameters The context about the order fulfillment and any
     *                       supplied extraData.
     *
     * @return validOrderMagicValue The magic value that indicates a valid
     *                              order.
     */
    function validateOrder(ZoneParameters calldata zoneParameters) external returns (bytes4 validOrderMagicValue) {
        bytes calldata extraData = zoneParameters.extraData;
        ArbitraryIntentData calldata arbitraryIntentData;
        // manually create a calldata pointer to arbitraryIntentData directly
        // validation is unnecessary because comparing the resulting CREATE2 address to the zoneHash implicitly does
        // that
        assembly {
            arbitraryIntentData := add(extraData.offset, 0x20)
        }

        // copy initcode to memory
        bytes memory arbitraryIntentInit = arbitraryIntentData.initData;
        // get salt for CREATE2
        bytes32 arbitraryIntentSalt = arbitraryIntentData.salt;

        // load zoneHash from calldata and declare variable to store the result of comparing CREATE2 address to
        // zoneHash
        bytes32 zoneHash = zoneParameters.zoneHash;
        bool validZoneHash;

        assembly {
            // store resulting create2 address
            let result := create2(0, add(arbitraryIntentInit, 0x20), mload(arbitraryIntentInit), arbitraryIntentSalt)
            // check if resulting address matches zoneHash
            validZoneHash := eq(result, zoneHash)
            // check if any data was returned – assume that if data was returned, it was a revert message
            if returndatasize() {
                // if data was returned, revert with that data
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }

        if (!validZoneHash) {
            revert InvalidExtraData();
        }

        return ZoneInterface.validateOrder.selector;
    }

    /**
     * @dev Returns the metadata for this zone.
     *
     * @return name The name of the zone.
     * @return schemas The schemas that the zone implements.
     */
    function getSeaportMetadata() external pure returns (string memory name, Schema[] memory schemas) {
        return ("Circus", schemas);
    }

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return interfaceId == type(ZoneInterface).interfaceId;
    }
}
