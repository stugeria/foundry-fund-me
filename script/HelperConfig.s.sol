// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public currNetworkConfig;
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    struct  NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if(block.chainid == 11155111) {
            currNetworkConfig = getSepoliaEthConfig();
        } else {
            currNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig () public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig () public returns (NetworkConfig memory) {
        //If anvil is already deployed, this ensures a new mock contract is not created and the existing one is used
        if(currNetworkConfig.priceFeed != address(0)){
            return currNetworkConfig;
        }

        //create a new mock contract with the initial price on Anvil
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS, 
            INITIAL_PRICE
            );
        vm.stopBroadcast();
        NetworkConfig memory anvilEthConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
            });
        return anvilEthConfig;

    }
}