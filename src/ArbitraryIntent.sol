// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title ArbitraryIntent
 * @author emo.eth
 * @notice This template is meant to be used in concert with the Circus zone to make arbitrary assertions about smart
 *         contract and chain state.
 */
abstract contract ArbitraryIntent {
    constructor() payable {
        expressIntent();
        // finalize by returning nothing – saving gas
        assembly {
            return(0, 0)
        }
    }

    /**
     * @dev Make arbitrary assertions about smart contract and chain state
     */
    function expressIntent() internal virtual;
}
