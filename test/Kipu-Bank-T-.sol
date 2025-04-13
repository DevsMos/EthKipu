// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/KipuBank.sol";

contract KipuBankTest is Test {
    KipuBank kipu;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        kipu = new KipuBank(5 ether);
    }

    function testInitialBankCap() public {
        assertEq(kipu.i_bankCap(), 5 ether);
    }

    function testDepositIncreasesBalance() public {
        vm.prank(user1);
        kipu.deposit{value: 1 ether}();

        assertEq(address(kipu).balance, 1 ether);
    }

    function testDepositEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit KipuBank.KipuBank_Deposit(user1, 1 ether);

        vm.prank(user1);
        kipu.deposit{value: 1 ether}();
    }

    function testRevertWhenDepositExceedsCap() public {
        vm.prank(user1);
        kipu.deposit{value: 4 ether}();

        vm.prank(user2);
        vm.expectRevert(KipuBank.KipuBank_ExceedsBankCapacity.selector);
        kipu.deposit{value: 2 ether}(); // Total > 5 ether
    }

    function testWithdrawWithinLimit() public {
        vm.prank(user1);
        kipu.deposit{value: 1 ether}();

        vm.prank(user1);
        kipu.withdraw(0.5 ether);

        assertEq(address(user1).balance, 0.5 ether); // Se testado com vm.deal
    }

    function testRevertWhenWithdrawExceedsLimit() public {
        vm.prank(user1);
        kipu.deposit{value: 2 ether}();

        vm.prank(user1);
        vm.expectRevert(KipuBank.KipuBank_ExceedsWithdrawalLimit.selector);
        kipu.withdraw(2 ether); // > 1 ether
    }

    function testRevertWithdrawWithInsufficientBalance() public {
        vm.prank(user1);
        kipu.deposit{value: 0.3 ether}();

        vm.prank(user1);
        vm.expectRevert(KipuBank.KipuBank_InsufficientBalance.selector);
        kipu.withdraw(0.5 ether);
    }
}
