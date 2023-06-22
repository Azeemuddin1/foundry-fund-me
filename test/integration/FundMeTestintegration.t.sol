// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
import {FundFundme ,WithdrawFundme } from "../../script/Interactions.s.sol";
contract FundMeTestintgration is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE =1;
    function setUp() external{
        DeployFundme deploy = new DeployFundme();
        fundMe = deploy.run();
        vm.deal(USER,STARTING_BALANCE);
    }
    function testUserCanFundInteractions() public {
        FundFundme fundFundme = new FundFundme();
        fundFundme.fundFundMe(address(fundMe));
       
        WithdrawFundme  withdrawFundMe = new WithdrawFundme();
        withdrawFundMe.withdrawFundme(address(fundMe));

        assertEq(address(fundMe).balance,0);
    }
}