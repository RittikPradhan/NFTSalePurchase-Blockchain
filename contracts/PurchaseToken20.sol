//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract PurchaseToken20 is ERC20 {
    address private deX;
    address private owner;

    event DeXUpdated(address indexed oldAddress, address indexed newAddress);

    constructor() ERC20 ("PurchaseToken20", "PT20") {
        _mint(msg.sender, 10 * 10 ** 18);
        owner = msg.sender;
    }

    function mintNew(address addr, uint256 amount) external {
        require(callerIsOwner(msg.sender),  "Caller isn't DeX");
        _mint(addr, amount);
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