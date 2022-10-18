//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "./PurchaseToken20.sol";
import "./NFTToken721.sol";
import "./Ownable.sol";
import "./ReentrancyGuard.sol";

contract Dex is Ownable, ReentrancyGuard {
    PurchaseToken20 PT20;
    NFTToken721 NFT721;

    address private feeCollector;

    uint256 constant PRICE = 1000000;

    event TokenMinted(address indexed, uint256, uint256);
    event BuyNFT(address indexed owner, uint256 tokenId);
    event SellNFT(address indexed owner, uint256 tokenId);


    constructor(address PT20Address, address NFT721Address, address _feeCollector) {
        PT20 = PurchaseToken20(PT20Address);
        NFT721 = NFTToken721(NFT721Address);
        feeCollector = _feeCollector;
    }

    function exchangeEthToPurchaseToken() external payable {
        uint256 tokenAmount;

        require(msg.sender.code.length == 0, "!EOA");

        tokenAmount = (msg.value * PRICE)/(10 ** 18);
        PT20.mintNew(msg.sender, tokenAmount);

        emit TokenMinted(msg.sender, msg.value, tokenAmount);
    }

    
    function buyNFT() external {
        require(PT20.balanceOf(msg.sender) > PRICE, "Insufficient token to buy NFT");
        PT20.approve(address(this), PRICE);
        PT20.transferFrom(msg.sender, address(this), PRICE);

        uint256 nftId = NFT721.mintNewNFT("https://buy.example/api/item/{newNFTID}.json");
        NFT721.transferFrom(address(this), msg.sender, nftId);

        emit BuyNFT(msg.sender, nftId);
    }

    function sellNFT(uint256 nftId) external {
        bool success = NFT721.burnNFT(msg.sender, nftId);
        require(success, "Failed to sell");

        uint256 receivableAmount = PRICE - (PRICE * 17)/1000 ;
        uint256 fee = (PRICE * 17)/1000;
        PT20.transferFrom(address(this), msg.sender, receivableAmount);
        PT20.transferFrom(address(this), feeCollector, fee);

        emit SellNFT(msg.sender, nftId);
    }

    function updateDeXAddress(address newDexAddress) external onlyOwner{
        PT20.setNewDeXAddress(address(this), newDexAddress);
        NFT721.setNewDeXAddress(address(this), newDexAddress);
    }
}