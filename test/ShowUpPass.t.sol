// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/ShowUpPassMinter.sol";

contract ShowUpPassTest is Test {
    ShowUpPass public showUpPass;
    address public constant alice = address(1);
    address public constant bob = address(2);

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

    function testWhitelistMint() public {
        ShowUpPassMinter showUpPassMinter = new ShowUpPassMinter(address(showUpPass));
        bytes32 aliceHash = keccak256(abi.encodePacked(alice));
        bytes32 bobHash = keccak256(abi.encodePacked(bob));
        bytes32 merkleRoot = keccak256(abi.encodePacked(aliceHash, bobHash));
        showUpPassMinter.setWhitelist(merkleRoot);
        showUpPass.setMinter(0, address(showUpPassMinter));

        bytes32[] memory proof = new bytes32[](1);

        vm.prank(alice);
        vm.deal(alice, 1 ether);
        proof[0] = bobHash;
        showUpPassMinter.whitelistMint{value: 1 ether}(alice, 1, proof);

        vm.prank(bob);
        vm.deal(bob, 1 ether);
        proof[0] = aliceHash;
        showUpPassMinter.whitelistMint{value: 1 ether}(bob, 2, proof);
    }
}
