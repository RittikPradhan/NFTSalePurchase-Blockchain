//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "./PurchaseToken20.sol";
import "./NFTToken721.sol";

contract Dex {
    PurchaseToken20 PT20;
    NFTToken721 NFT721;

    address private feeCollector;

    uint256 constant PRICE = 1000000;

    event BuyNFT(address indexed owner, uint256 tokenId);
    event SellNFT(address indexed owner, uint256 tokenId);
    event TokenMinted(address indexed owner, uint256 ethAmount, uint256 tokenAmount);
    event TokenBurned(address indexed owner, uint256 ethAmount, uint256 tokenAmount);

    constructor(address PT20Address, address NFT721Address, address _feeCollector) {
        PT20 = PurchaseToken20(PT20Address);
        NFT721 = NFTToken721(NFT721Address);
        feeCollector = _feeCollector;
    }

    function exchangeEthToPurchaseToken() external payable {
        require(msg.value > 0, "Insufficient Supply");

        uint256 tokenAmount = (msg.value * PRICE);
        PT20.mint(msg.sender, tokenAmount);

        emit TokenMinted(msg.sender, msg.value, tokenAmount);
    }

    function buyNFT() external {

        require(PT20.balanceOf(msg.sender) >= PRICE, "Insufficient token to buy NFT");
        PT20.transferFrom(msg.sender, address(this), PRICE);

        uint256 nftId = NFT721.mint(msg.sender);

        emit BuyNFT(msg.sender, nftId);
    }

    function sellNFT(uint256 nftId) external {
        NFT721.burn(msg.sender, nftId);

        uint256 fee = (PRICE * 17)/1000;
        uint256 receivableAmount = PRICE - fee ;
 
        PT20.transfer(msg.sender, receivableAmount);
        PT20.transfer(feeCollector, fee);

        emit SellNFT(msg.sender, nftId);
    }

    function exchangePurchaseTokenToEth(uint256 amount) external {

        require(PT20.balanceOf(msg.sender) >= amount, "Insufficient Token Balance");
        require(amount >= PRICE, "Min. 1000000 Token to get 1 wei");

        uint256 ethAmount = (amount/PRICE) ;
        (bool success, ) = msg.sender.call{value: ethAmount}("");
        require(success, "Eth not transferred");
        PT20.burn(msg.sender, amount);
        
        emit TokenBurned(msg.sender, ethAmount, amount);
    }
}