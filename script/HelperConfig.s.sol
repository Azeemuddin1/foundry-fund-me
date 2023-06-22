// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator}  from "../test/mocks/MockV3Aggregator.sol";
//1 deploy mocks when we are on a local chain
//2 keep tracking addresses
contract HelperConfig is Script{
    
    // if we are on local chain deploy mock contracts
    // if we are on live chain get existing address
    uint8 public constant DECIMAL =8;
    int256 public constant INITAL_PRICE=2000e8;
    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig public activeNetworkConfig;

    constructor(){
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        } else if(block.chainid == 1){
            activeNetworkConfig = getEthMaiNetConfig();
        }

        else {
            activeNetworkConfig = getorCreateAnvilConfig();
        }
    }
    function getSepoliaEthConfig() public pure  returns (NetworkConfig memory) {
        NetworkConfig  memory sepoliaConfig = NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }
    function getEthMaiNetConfig() public pure returns(NetworkConfig memory){
         NetworkConfig memory ethmainnetconfig = NetworkConfig({
            priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
         });
         return ethmainnetconfig;
    }

    function getorCreateAnvilConfig() public returns(NetworkConfig memory){
           // if contract is already deployed then no need to deploy it agian
           // it will return the deployed contract address
            if(activeNetworkConfig.priceFeed != address(0)){
                return activeNetworkConfig;
            }
     
        vm.startBroadcast();
        MockV3Aggregator mockpricfeed = new MockV3Aggregator(DECIMAL,INITAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed:address(mockpricfeed)});
    return anvilConfig;
    }
}