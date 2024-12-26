// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/UltraTaiwan.sol";
import "../src/Minter.sol";

contract MinterScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        uint256 price = 0.2 ether;
        uint256 amount = 50;
        uint256 startTime = 1673971200;
        address receiver = address(0x85799fB555A2D69725B1476aF3aCe7351027723D);

        Minter minter = new Minter(price, amount, startTime, receiver);

        ShowUpPass showUpPass = minter.showUpPass();
        UltraTaiwan ultraTaiwan = minter.ultraTaiwan();

        console2.log("ShowUpPass:", address(showUpPass));
        console2.log("UltraTaiwan:", address(ultraTaiwan));
        console2.log("UltraTaiwanStub:", address(ultraTaiwan.stub()));
        console2.log("Minter:", address(minter));
        console2.log("Receiver:", minter.receiver());
        vm.stopBroadcast();
    }
}
