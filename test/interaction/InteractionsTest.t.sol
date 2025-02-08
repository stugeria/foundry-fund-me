//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/InteractionsFundMe.s.sol";

contract IntreationsTest is Test{

    FundMe fundMe; //storaging the test contract deployed
    uint256 constant private VALUE = 0.1 ether; // value funded for testing
    address private TESTER = makeAddr("tester"); //create a new address for testing
    uint256 constant private OPENING_BAL = 10 ether; //opening balance of TESTER

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(TESTER, OPENING_BAL);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}