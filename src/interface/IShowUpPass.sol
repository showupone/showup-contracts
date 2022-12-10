// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IShowUpPass {
    function mint(address to, uint256 id, uint256 amount, bytes memory data) external payable;
}
