// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./token.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.1/contracts/utils/math/SafeMath.sol";


contract CornPopIco {

    using SafeMath for uint256;

    uint256 public balance = 50000000;
    address owner;
    mapping(address => bool) whitelist;
    mapping(address => uint) accountBalances;
    uint256 maxLimit = 1000000;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function CornPopICO(address _tokenAddr) public {
        token = CornPop(_tokenAddr);
        owner = msg.sender;
    }

    CornPop token;

    uint256 public RATE = 50000; // 1 ETH = 50000 CPOP

    // The owner can whitelist addresses.
    function whitelistAddress(address _address) public onlyOwner {
        require(!whitelist[_address], "Whitelist: Caller must not already be whitelisted");
        whitelist[_address] = true;
        accountBalances[_address] = 0;
    }


    // Returns the amount of tokens that the user will get based on the current rate.
    function _getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
        return _weiAmount.div(10 ** 18).mul(RATE);
    }

    // Checks if the user had already bought more tokens then the amount that he is allowed to.
    function hasBoughtEnough(address _address, uint256 amount) private returns (bool){
        if (accountBalances[_address].add(amount) <= maxLimit) {
            return true;
        } else {
            return false;
        }
    }

    function getTokens() public payable {
        require(whitelist[msg.sender], "Whitelist: Caller is not whitelisted");
        uint256 weiAmnt = msg.value;
        uint256 _amount = _getTokenAmount(weiAmnt);
        // Checks if the balance would be greater then 0 after the withdrawl.
        if (balance.sub(_amount) >= 0) {
            require(hasBoughtEnough(msg.sender, _amount));
            balance = balance.sub(_amount);
            accountBalances[msg.sender] += _amount;
            token.transfer(msg.sender, _amount);
        }

    }
}