// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/RoadToUltraTaiwan.sol";
import "../src/RoadToUltraTaiwanStub.sol";
import "../src/Minter.sol";

contract MinterTest is Test {
    ShowUpPass public showUpPass;
    RoadToUltraTaiwan public roadToUltraTaiwan;
    RoadToUltraTaiwanStub public roadToUltraTaiwanStub;

    address public constant alice = address(1);
    address public constant bob = address(2);

    function setUp() public {
        showUpPass = new ShowUpPass();
        roadToUltraTaiwan = new RoadToUltraTaiwan();
        roadToUltraTaiwanStub = roadToUltraTaiwan.stub();
    }

    function testMint() public {
        Minter minter = new Minter(address(showUpPass), address(roadToUltraTaiwan));
        showUpPass.setMinter(address(minter));
        roadToUltraTaiwan.setMinter(address(minter));

        vm.prank(alice);
        vm.deal(alice, 1 ether);
        minter.mint{value: 1 ether}(alice, 2);
    }

    function testWhitelistMint() public {
        Minter minter = new Minter(address(showUpPass), address(roadToUltraTaiwan));
        showUpPass.setMinter(address(minter));
        roadToUltraTaiwan.setMinter(address(minter));

        bytes32 aliceHash = keccak256(bytes.concat(keccak256(abi.encode(alice))));
        bytes32 bobHash = keccak256(bytes.concat(keccak256(abi.encode(bob))));
        bytes32 merkleRoot = keccak256(abi.encodePacked(bobHash, aliceHash));
        minter.setWhitelist(merkleRoot);

        bytes32[] memory proof = new bytes32[](1);

        vm.deal(alice, 1 ether);
        proof[0] = bobHash;
        vm.prank(alice);
        minter.whitelistMint{value: 1 ether}(alice, 1, proof);

        vm.deal(bob, 1 ether);
        proof[0] = aliceHash;
        vm.prank(bob);
        minter.whitelistMint{value: 1 ether}(bob, 2, proof);
    }

    function testRedeem() public {
        Minter minter = new Minter(address(showUpPass), address(roadToUltraTaiwan));
        showUpPass.setMinter(address(minter));
        roadToUltraTaiwan.setMinter(address(minter));

        vm.deal(alice, 1 ether);
        vm.prank(alice);
        minter.mint{value: 1 ether}(alice, 1);

        assert(roadToUltraTaiwan.balanceOf(alice) == 1);
        assert(roadToUltraTaiwanStub.balanceOf(alice) == 0);

        uint256 tokenId = roadToUltraTaiwan.tokenOfOwnerByIndex(alice, 0);
        vm.prank(alice);
        roadToUltraTaiwan.redeem(tokenId);
        assert(roadToUltraTaiwan.balanceOf(alice) == 0);
        assert(roadToUltraTaiwanStub.balanceOf(alice) == 1);
    }
}
