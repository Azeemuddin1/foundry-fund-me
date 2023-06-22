/// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity  ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundme is Script {
    uint256 constant SEND_VALUE = 0.1 ether;
    function fundFundMe(address mostRecentDeployed) public{
     vm.startBroadcast();
    FundMe(payable(mostRecentDeployed)).fund{value:SEND_VALUE}();   
    vm.stopBroadcast();
    console.log("Funded fundme ",SEND_VALUE);    
    }
   function  run() public {
    address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
        "FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
         vm.stopBroadcast(); 
   }
}

contract WithdrawFundme is Script{
        function withdrawFundme(address mostRecentDeployed) public{
     vm.startBroadcast();
    FundMe(payable(mostRecentDeployed)).withdraw(); 
     vm.stopBroadcast();
    }
   function  run() external {
    address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
        "FundMe", block.chainid);
        vm.startBroadcast();
        withdrawFundme(mostRecentDeployed);
         vm.stopBroadcast(); 
   }

}