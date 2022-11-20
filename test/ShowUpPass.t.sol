// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/ShowUpPassMinter.sol";

contract ShowUpPassTest is Test {
    ShowUpPass public showUpPass;
    address public constant alice = address(1);

    function setUp() public {
        showUpPass = new ShowUpPass();
    }

    function testMint() public {
        ShowUpPassMinter showUpPassMinter = new ShowUpPassMinter(address(showUpPass));
        showUpPass.setMinter(0, address(showUpPassMinter));
        vm.prank(alice);
        vm.deal(alice, 1 ether);
        showUpPassMinter.mint{value: 1 ether}(alice, 1);
    }
}
