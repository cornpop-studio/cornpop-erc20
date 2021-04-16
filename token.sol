pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract CornPop is StandardToken {
    string public name = "CornPop";
    string public symbol = "CPOP";
    uint8 public decimals = 0;
    address owner;

    uint256 public FOR_ICO = 750000;
    uint256 public FOR_FOUNDER = 250000;

    function CornPop() public {
        owner = msg.sender;
        totalSupply_ = FOR_FOUNDER + FOR_ICO;
        balances[msg.sender] = totalSupply_;

    }

    modifier _ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    function fundICO(address _icoAddr) _ownerOnly public payable {
        transfer(_icoAddr, FOR_ICO);
    }
}