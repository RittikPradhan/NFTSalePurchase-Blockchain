//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "./TokenA.sol";
import "./TokenB.sol";
import "./Ownable.sol";
import "./ReentrancyGuard.sol";

contract Dex is Ownable, ReentrancyGuard {
    TokenA tA;
    TokenB tB;

    event TokenMinted(address indexed, uint256, uint256);
    event SetNFTAddress(address indexed, address indexed);
    event BuyNFT(address indexed owner, uint256 tokenId);
    event SellNFT(address indexed oldOwner, address indexed newOwner, uint256 tokenId);


    constructor(address tA20Address, address tB721Address) {
        tA = TokenA(tA20Address);
        tB = TokenB(tB721Address);
    }

    function exchangeEthToTokenA() external payable {
        uint256 tokenAmount;

        require(msg.sender.code.length == 0, "!EOA");

        tokenAmount = (msg.value * 1000000)/(10 ** 18);
        tA.mintNew(msg.sender, tokenAmount);

        emit TokenMinted(msg.sender, msg.value, tokenAmount);
    }

    
    function buyNFT() external {
    }

    function sellNFT() external {
    }

    function updateDeXAddress(address newDexAddress) external onlyOwner{
        tA.setNewDeXAddress(address(this), newDexAddress);
        tB.setNewDeXAddress(address(this), newDexAddress);
    }
}