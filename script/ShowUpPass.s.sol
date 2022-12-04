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
        console2.log("showUpPass:", address(showUpPass));
        console2.log("showUpPassMinter:", address(showUpPassMinter));
        vm.stopBroadcast();
    }
}
