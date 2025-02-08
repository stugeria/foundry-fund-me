// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";


contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.1 ether;
    
    function fundFundMe(address mostRecentDepolyed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDepolyed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    function run() external {
      
        address mostRecentContract = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        
        fundFundMe(mostRecentContract);
    }
}

contract WithdrawFundMe is Script {
    
    function withdrawFundMe(address mostRecentDepolyed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDepolyed)).withdraw();
        vm.stopBroadcast();

    }

    function run() external {
      
        address mostRecentContract = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentContract);
    }
}