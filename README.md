# The Circus

## Q: What do Seaport Orders and The Circus have in common?
A: They're both intents.

----

## Usage

`TheCircusZone` is a proof-of-concept Seaport Zone that takes `extraData` in the form of an abi-encoded struct:

```solidity
struct ArbitraryIntentData {
    bytes initData;
    bytes32 salt;
}
```

This data is used to CREATE2 an ephemeral smart contract designed to be a container to execute arbitrary logic within its constructor, without actually writing code to the chain.

This allows for expressive, arbitrary assertions to be made by `TheCircusZone`, to emphasize Seaport's potential as an "intent" protocol; a signed Seaport order will not be fulfillable unless all `ConsiderationItem`s are satisified _in addition_ to any arbitrary checks specified by an `ArbitraryIntent`. Since Zones can both read _and_ write arbitrary data, this allows for a wide range of use cases.

### TheCircusZOne

A simple zone that reads the `extraData` from the `ZoneParameters` as an `ArbitraryIntentData` struct. It calls `CREATE2` using this data, and reverts if any data returned, otherwise passing the `validateOrder` check.

### ArbitraryIntent

An abstract template contract for executing arbitrary code within the context of a Seaport Zone – "intent" logic is implemented in the `expressIntent()` function. If a revert is specified with a non-zero amount of data, `TheCircusZone` will revert with this data, otherwise, the `validateOrder` check will pass.

### `test/helpers/SpecificIntent.sol`

A very simple "specific" Intent that reverts if a particular smart contract has not been deployed.