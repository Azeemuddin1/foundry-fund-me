// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";

contract FundMeTest is Test {
        FundMe fundme;
address USER = makeAddr("user");
uint256 constant SEND_VALUE = 0.1 ether;
uint256 constant STARTING_BALANCE =10 ether;
uint256 constant GAS_PRICE = 1;

    function setUp() external {
      DeployFundme deployfundme = new DeployFundme();
      fundme = deployfundme.run();
      vm.deal(USER,STARTING_BALANCE);
    }
    function testMinimumDollerIsFive() public{
      assertEq(fundme.MINIMUM_USD(),5e18);
    }

  function testOwnerIsMsgSender() public {
  
    assertEq(fundme.getOwner(), msg.sender);
  }

  function testPriceFeedVersion() public {
    uint256 version= fundme.getVersion();
    assertEq(version,4);

  }

  function testFundmeFailsWithOutEnoughETH() public {
    vm.expectRevert();
    fundme.fund();

  }

  function testFundmeUpatesFundsDataStructs() public funded {
    uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
    assertEq(amountFunded,SEND_VALUE);
  }

  function testAddsFunderToArrayOfFunders() public funded {
    address funder = fundme.getFunder(0);
    assertEq(USER,funder);
  }
  modifier funded(){
    vm.prank(USER);
  fundme.fund{value:SEND_VALUE}();
  _;

  }
function testOnlyOwnercanWithDraw() public funded {
  vm.expectRevert();
  vm.prank(USER);
  fundme.withdraw();
}
function testWithdrawWithASingleFunder() public funded {
  // Arrange
 uint256 startingOwnerBalance = fundme.getOwner().balance;
 uint256 startingFundmeBalance = address(fundme).balance;
  //Account
//  vm.txGasPrice(GAS_PRICE);
    vm.prank(fundme.getOwner());
    fundme.withdraw();
  // Assert
 uint256 endingOwnerBalance = fundme.getOwner().balance;
 uint256 endingFundmeBalance = address(fundme).balance;
 assertEq(endingFundmeBalance ,0);
 assertEq(startingFundmeBalance + startingOwnerBalance , endingOwnerBalance);
}


function testcheaperWithdrawFromMultipeFunders() public funded {
  //Arrange
  uint160 numberOfFunders =10;
  uint160 startingFunderIndex =1;
  for(uint160 i=startingFunderIndex;i < numberOfFunders ; i++){
    hoax(address(i),SEND_VALUE);
    fundme.fund{value:SEND_VALUE}();
  }

  uint256 startingBalanceOfOwner = fundme.getOwner().balance;
  uint256  startingBalanceOfFundme = address(fundme).balance;
// account
 // vm.txGasPrice(GAS_PRICE);
  vm.startPrank(fundme.getOwner());
  fundme.cheaperwithdraw();
  vm.stopPrank();

  //Action
  uint256 endingBalanceOfOwner = fundme.getOwner().balance;
  uint256 endignBalanceOfFundme = address(fundme).balance;
  assertEq(endignBalanceOfFundme ,0);
  assertEq(endingBalanceOfOwner , startingBalanceOfOwner + startingBalanceOfFundme);

}
function testWithdrawFromMultipeFunders() public funded {
  //Arrange
  uint160 numberOfFunders =10;
  uint160 startingFunderIndex =1;
  for(uint160 i=startingFunderIndex;i < numberOfFunders ; i++){
    hoax(address(i),SEND_VALUE);
    fundme.fund{value:SEND_VALUE}();
  }

  uint256 startingBalanceOfOwner = fundme.getOwner().balance;
  uint256  startingBalanceOfFundme = address(fundme).balance;
// account
 // vm.txGasPrice(GAS_PRICE);
  vm.startPrank(fundme.getOwner());
  fundme.withdraw();
  vm.stopPrank();

  //Action
  uint256 endingBalanceOfOwner = fundme.getOwner().balance;
  uint256 endignBalanceOfFundme = address(fundme).balance;
  assertEq(endignBalanceOfFundme ,0);
  assertEq(endingBalanceOfOwner , startingBalanceOfOwner + startingBalanceOfFundme);

}
}