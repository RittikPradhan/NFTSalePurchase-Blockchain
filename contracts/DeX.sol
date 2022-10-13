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

    constructor(address tA20Address, address tB721Address) {
        tA = TokenA(tA20Address);
        tB = TokenB(tB721Address);
        _setDexAddress();
    }

    function exchangeEthToTokenA() external payable {
        uint256 tokenAmount;

        require(msg.value > 1 ether, "Insufficient Eth");
        require(msg.sender.code.length != 0, "!EOA");
        require(msg.sender != address(0), "Zero Address");

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

    function _setDexAddress() private {
        tA.setNewDeXAddress(address(0), address(this));
        tB.setNewDeXAddress(address(0), address(this));
    }
}