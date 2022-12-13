// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/ShowUpPassMinter.sol";

contract ShowUpPassScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ShowUpPass showUpPass = new ShowUpPass();
        ShowUpPassMinter showUpPassMinter = new ShowUpPassMinter(
            address(showUpPass)
        );
        showUpPass.setMinter(0, address(showUpPassMinter));
        bytes32 address1Hash =
            keccak256(bytes.concat(keccak256(abi.encode(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266))));
        bytes32 address2Hash =
            keccak256(bytes.concat(keccak256(abi.encode(0x70997970C51812dc3A010C7d01b50e0d17dc79C8))));
        bytes32 merkleRoot = keccak256(abi.encodePacked(address2Hash, address1Hash));
        showUpPassMinter.setWhitelist(merkleRoot);
        console2.log("showUpPass:", address(showUpPass));
        console2.log("showUpPassMinter:", address(showUpPassMinter));
        vm.stopBroadcast();
    }
}
