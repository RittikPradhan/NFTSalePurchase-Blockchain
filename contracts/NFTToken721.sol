//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTToken721 is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private tokenIds;

    constructor() ERC721 ("NFTToken721", "NT721") {
    }

    //Only DeX contract can call mint function.
    function mint(address owner) external onlyOwner returns(uint256) {

        tokenIds.increment();
        uint256 newNFTID = tokenIds.current();
        _mint(owner, newNFTID);
        _setTokenURI(newNFTID, "NFT");

        return newNFTID;
    }

    //Only DeX contract can call burn function.
    function burn(address userAddress, uint256 tokenId) external onlyOwner {
        require(ownerOf(tokenId) == userAddress, "!nftOwner");
        _burn(tokenId);
    }
}