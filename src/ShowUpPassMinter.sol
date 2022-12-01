// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interface/IShowUpPass.sol";

contract ShowUpPassMinter {
    IShowUpPass public showUpPass;

    constructor(address _showUpPass) {
        showUpPass = IShowUpPass(_showUpPass);
    }

    function mint(address account, uint256 amount) external payable {
        // TODO: check price
        // TODO: check max supply
        showUpPass.mint(account, 0, amount, "");
    }
}
