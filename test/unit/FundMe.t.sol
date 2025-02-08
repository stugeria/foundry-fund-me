//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{

    FundMe fundMe; //storaging the test contract deployed
    uint256 constant private VALUE = 0.1 ether; // value funded for testing
    address private TESTER = makeAddr("tester"); //create a new address for testing
    uint256 constant private OPENING_BAL = 10 ether; //opening balance of TESTER

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(TESTER, OPENING_BAL);
    }

    function testMinimumUsdIsFive() view public {
        console.log("Testing...");
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOnwerIsMsgSender() view public {
        assertEq(fundMe.getOwner(), address(msg.sender));
    }

    function testPriceFeedVersion() view public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsIfNotEnoughETH() public {
        vm.expectRevert(); //Check if next link fails/reverts
        fundMe.fund();
    }

    //Allow testing on a funded contract
    modifier funded() {
        vm.prank(TESTER); //the tx will be sent by this user address.
        fundMe.fund{value: VALUE}();
        _;
    }

    function testAddresstoAmountFunded() public funded{
        assertEq(fundMe.getAddressToAmountFunded(TESTER), VALUE);
    }

    function testFunderIsAddedToArray() public funded{
        assertEq(fundMe.getFunder(0), TESTER);
    }

    function testOnlyOwnerCanWithdraw() public funded{
        vm.expectRevert(); //Check if next line fails/reverts. Ignores vm lines of code.
        vm.prank(TESTER);
        fundMe.withdraw();
    }

    function testWithdrawFundsAsSingleFunder() public funded{
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundBalance = address(fundMe).balance;
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundBalance);
        assertEq(endingFundBalance, 0);
    }

    function testWithdrawFundsAsMultipleFunder() public funded{
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint160 funderIndex = 1;
        uint160 numberOfFunders = 10;
        for (uint160 i = funderIndex; i < numberOfFunders; i++) {
            hoax(address(i), VALUE);
            fundMe.fund{value: VALUE}();
        }

        uint256 startingFundBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundBalance = address(fundMe).balance;
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundBalance);
        assertEq(endingFundBalance, 0);
    }

}