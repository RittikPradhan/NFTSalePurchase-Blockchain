//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NFTToken721 is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private tokenIds;
    address private deX;
    address private owner;

    event DeXUpdated(address indexed oldAddress, address indexed newAddress);

    constructor() ERC721 ("NFTToken721", "NT721") {
    }

    function mintNewNFT(string memory tokenURI) external returns(uint256) {

        require(callerIsDeX(msg.sender), "Caller isn't DeX");

        tokenIds.increment();
        uint256 newNFTID = tokenIds.current();
        _mint(msg.sender, newNFTID);
        _setTokenURI(newNFTID, tokenURI);
        setApprovalForAll(deX, true);

        return newNFTID;
    }

    function burnNFT(address owner, uint256 tokenId) external returns(bool) {
        address nftOwner = ownweOf(tokenId);

        require(owner == nftOwner, "!nftOwner");
        require(callerIsOwner(msg.sender), "Caller isn't Owner");
        _burn(tokenId);

        return true;
    }

    function setNewDeXAddress(address oldAddress, address newAddress) external {
        require(deX == oldAddress, "Not DeX");
        require(callerIsOwner(msg.sender), "Caller isn't Owner");
        require(deX != newAddress, "New Address Can't Be Old Address");
        require(newAddress != address(0), "Zero Address");

        deX = newAddress;
        owner = newAddress;
        emit DeXUpdated(oldAddress, newAddress);

    }

    function callerIsOwner(address addr) private view returns(bool) {
        if(addr == owner)
            return true;

        return false;
        }
}