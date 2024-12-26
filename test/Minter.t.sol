// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/UltraTaiwan.sol";
import "../src/UltraTaiwanStub.sol";
import "../src/Minter.sol";

contract MinterTest is Test {
    Minter public minter;
    ShowUpPass public showUpPass;

    address public constant alice = address(1);
    address public constant bob = address(2);

    function setUp() public {
        minter = new Minter(1 ether, 50, block.timestamp, bob);
        showUpPass = minter.showUpPass();
        ultraTaiwan = minter.ultraTaiwan();
        ultraTaiwanStub = ultraTaiwan.stub();
    }

    function testMint() public {
        vm.deal(alice, 2 ether);
        vm.prank(alice);
        minter.mint{value: 2 ether}(alice, 2);

        assert(bob.balance == 2 ether);
    }

    function testRedeem() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        minter.mint{value: 1 ether}(alice, 1);

        assert(ultraTaiwan.balanceOf(alice) == 1);
        assert(ultraTaiwanStub.balanceOf(alice) == 0);

        uint256 tokenId = ultraTaiwan.tokenOfOwnerByIndex(alice, 0);
        vm.prank(alice);
        ultraTaiwan.redeem(alice, tokenId);
        assert(ultraTaiwan.balanceOf(alice) == 0);
        assert(ultraTaiwanStub.balanceOf(alice) == 1);

        ultraTaiwanStub.setTransferableTimestamp(block.timestamp);
        vm.prank(alice);
        ultraTaiwanStub.transferFrom(alice, bob, tokenId);
    }
}
