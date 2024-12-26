// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/Test.sol";
import "../src/ShowUpPass.sol";
import "../src/MinterV2.sol";

contract MinterV2Script is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        uint256 price = 0.2 ether;
        uint256 maxSupply = 50000;
        address receiver = address(0x85799fB555A2D69725B1476aF3aCe7351027723D);
        ShowUpPass showUpPass = ShowUpPass(0xA9bEeF3336016649F84ED52E9B62cCBdE048De63);

        MinterV2 minter = new MinterV2(showUpPass, price, maxSupply, receiver);
        showUpPass.setMinter(address(minter));

        console2.log("Minter:", address(minter));
        console2.log("Receiver:", minter.receiver());
        vm.stopBroadcast();
    }
}
