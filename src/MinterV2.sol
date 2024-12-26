// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./ShowUpPass.sol";

contract MinterV2 is Ownable, ReentrancyGuard {
    uint256 public price = 0.1 ether;
    uint256 public maxSupply = 100000;
    address public receiver;

    ShowUpPass public showUpPass;

    constructor(ShowUpPass _showUpPass, uint256 _price, uint256 _maxSupply, address _receiver) {
        showUpPass = _showUpPass;
        set(_price, _maxSupply, _receiver);
    }

    function set(uint256 _price, uint256 _maxSupply, address _receiver) public onlyOwner {
        require(_receiver != address(0), "receiver is zero address");
        price = _price;
        maxSupply = _maxSupply;
        receiver = _receiver;
    }

    function mint(address to, uint256 amount) external payable nonReentrant {
        require(msg.value >= amount * price, "not enough ether");
        require(showUpPass.totalSupply() + amount <= maxSupply, "max supply reached");

        for (uint256 i = 0; i < amount; i++) {
            showUpPass.mint(to);
        }

        (bool success,) = payable(receiver).call{value: address(this).balance}("");
        require(success, "transfer failed");
    }

    receive() external payable {}

    fallback() external payable {}
}
