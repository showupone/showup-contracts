// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./interface/IShowUpPass.sol";

contract ShowUpPassMinter {
    IShowUpPass public showUpPass;

    bytes32 public whitelistMerkleRoot = 0;
    mapping(address => uint256) public whitelistMintedAmount;

    constructor(address _showUpPass) {
        showUpPass = IShowUpPass(_showUpPass);
    }

    function setWhitelist(bytes32 merkleRoot) external {
        whitelistMerkleRoot = merkleRoot;
    }

    function whitelistMint(address to, uint256 amount, bytes32[] memory proof) external payable {
        // TODO: check price
        require(whitelistMerkleRoot != 0, "Whitelist not set");
        require(whitelistMintedAmount[to] + amount <= 2, "Exceed limit");
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(to))));
        require(MerkleProof.verify(proof, whitelistMerkleRoot, leaf), "Invalid proof");
        whitelistMintedAmount[to] += amount;
        showUpPass.mint(to, 0, amount, "");
    }

    function mint(address to, uint256 amount) external payable {
        // TODO: check price
        showUpPass.mint(to, 0, amount, "");
    }
}
