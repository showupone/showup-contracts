// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract ShowUpPass is ERC1155, Ownable, ERC1155Supply {
    mapping(uint256 => address) public minter;

    // mapping(uint256 => uint256) public maxSupply;
    // mapping(uint256 => uint256) public price;

    constructor() ERC1155("https://showup.one/metadata/{id}.json") {}

    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    function setMinter(uint256 id, address _minter) external onlyOwner {
        minter[id] = _minter;
    }

    // function set(uint256 id, uint256 _maxSupply, uint256 _price) external onlyOwner {
    //     maxSupply[id] = _maxSupply;
    //     price[id] = _price;
    // }

    // function withdraw() external onlyOwner {
    //     (bool success,) = msg.sender.call{value: address(this).balance}("");
    //     require(success, "Transfer failed.");
    // }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) external {
        // require(totalSupply(id) + amount <= maxSupply[id], "ShowUpPass: max supply reached");
        // require(msg.value == price[id] * amount, "ShowUpPass: incorrect price");
        require(msg.sender == minter[id], "ShowUpPass: FORBIDDEN");
        _mint(account, id, amount, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override (ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
