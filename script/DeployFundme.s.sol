
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundme is Script{
    
    function run() external returns(FundMe) {
        // Before startBroadCast -> Not a real tx
        HelperConfig helperConfig = new HelperConfig();
        // we are returning struct here for which we need () if we have multiple parameters then we will use (,,,)
        (address ethusdpriceFeed) = helperConfig.activeNetworkConfig();

        // After startBroadcast -> Real tx
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethusdpriceFeed);
        vm.stopBroadcast();
        return fundme;
    }


}