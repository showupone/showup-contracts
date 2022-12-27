// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./interface/IMintable.sol";

contract Minter {
    IMintable public showUpPass;
    IMintable public roadToUltraTaiwan;

    bytes32 public whitelistMerkleRoot = 0;
    mapping(address => uint256) public whitelistMintedAmount;

    constructor(address _showUpPass, address _roadToUltraTaiwan) {
        showUpPass = IMintable(_showUpPass);
        roadToUltraTaiwan = IMintable(_roadToUltraTaiwan);
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
        for (uint256 i = 0; i < amount; i++) {
            showUpPass.mint(to);
            roadToUltraTaiwan.mint(to);
        }
    }

    function mint(address to, uint256 amount) external payable {
        // TODO: check price
        for (uint256 i = 0; i < amount; i++) {
            showUpPass.mint(to);
            roadToUltraTaiwan.mint(to);
        }
    }
}
