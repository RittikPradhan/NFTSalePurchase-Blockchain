//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract TokenA is ERC20 {
    address private deX;

    event DeXUpdated(address indexed oldAddress, address indexed newAddress);

    constructor() ERC20 ("tokenA", "tA20") {
        _mint(msg.sender, 10 * 10 ** 18);
    }

    function mintNew(address addr, uint256 amount) external {
        require(callerIsDeX(msg.sender),  "Caller isn't DeX");
        _mint(addr, amount);
    }

        function setNewDeXAddress(address oldAddress, address newAddress) external {
        require(deX == oldAddress, "Not DeX");
        require(callerIsDeX(msg.sender), "Caller isn't DeX");
        require(deX != newAddress, "New Address Can't Be Old Address");
        require(newAddress != address(0), "Zero Address");

        deX = newAddress;

        emit DeXUpdated(oldAddress, newAddress);

    }
    
    function callerIsDeX(address addr) private view returns(bool) {
    if(addr == deX)
        return true;

    return false;
    }
}