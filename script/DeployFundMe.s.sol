// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //Not a real tx. No gas used
        HelperConfig helperConfig = new HelperConfig();
        
        // Deploy. Real Tx
        vm.startBroadcast();
        FundMe fundMe = new FundMe(helperConfig.currNetworkConfig());
        vm.stopBroadcast();
        return fundMe;
    }
}