// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./RoadToUltraTaiwanStub.sol";

contract RoadToUltraTaiwan is ERC721, ERC721Enumerable, ERC721Royalty, Ownable {
    using Counters for Counters.Counter;

    address public minter;
    RoadToUltraTaiwanStub public stub;

    Counters.Counter private _tokenIdCounter;
    string private baseURI_;

    constructor() ERC721("RoadToUltraTaiwan", "RTUTW") {
        stub = new RoadToUltraTaiwanStub();
        stub.setMinter(address(this));
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI_;
    }

    function setURI(string memory uri) external onlyOwner {
        baseURI_ = uri;
    }

    function setRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    function mint(address to) external {
        require(msg.sender == minter, "Not minter");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function redeem(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "Not owner");
        _burn(tokenId);
        stub.mint(msg.sender, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override (ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override (ERC721, ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override (ERC721, ERC721Royalty) {
        super._burn(tokenId);
    }
}
