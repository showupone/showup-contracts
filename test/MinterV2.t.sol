// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/MinterV2.sol";

contract MinterV2Test is Test {
    MinterV2 public minter;
    ShowUpPass public showUpPass;
    address public constant alice = address(1);
    address public constant bob = address(2);

    function setUp() public {
        showUpPass = new ShowUpPass();
        minter = new MinterV2(showUpPass, 1 ether, 50, bob);
        showUpPass.setMinter(address(minter));
    }

    function testMint() public {
        vm.deal(alice, 2 ether);
        vm.prank(alice);
        minter.mint{value: 2 ether}(alice, 2);

        assert(showUpPass.balanceOf(alice) == 2);
        assert(bob.balance == 2 ether);
    }
}
