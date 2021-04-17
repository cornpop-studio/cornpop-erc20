pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./token.sol";


contract CornpopIco {
    uint256 public balance = 750000;
    uint public mal = 0;
    address owner;
    mapping(address => bool) whitelist;
    mapping(address => uint) accountBalances;
    uint256 public whitelistedNumber = 0;
    uint256 STAGE0 = 750000;
    uint256 STAGE1 = 500000;
    uint256 STAGE2 = 250000;
    uint256 STAGE3 = 100000;
    uint256 STAGE4 = 0;
    uint256 public currentStage;
    uint256 public newStage = 0;
    uint256 public extraAmount;
    uint256 topAmount = 10;

    function CornPopICO(address _tokenAddr) public {
        token = CornPop(_tokenAddr);
        owner = msg.sender;
        currentStage = STAGE1;
    }

    modifier _ownerOnly(){
        require(msg.sender == owner);
        _;
    }
    using SafeMath for uint256;

    CornPop token;

    uint256 public RATE = 1000; // 1 ETH = 1000 CPOP
    uint256 public remainingStage = 1;

    function whitelistAddress(address _add) _ownerOnly public payable {
        require(!whitelist[_add], "Candidate must not be whitelisted.");
        whitelist[_add] = true;
        accountBalances[_add] = 0;
        whitelistedNumber++;

    }

    function checkStage(uint amnt) private returns (bool){
        bool change = false;
        uint newBalance = balance - amnt;
        if (newBalance <= STAGE1 && balance > STAGE1) {
            change = true;
        } else if (newBalance <= STAGE2 && balance > STAGE2) {
            change = true;
        } else if (newBalance <= STAGE3 && balance > STAGE3) {
            change = true;
        }
        return change;
    }

    function setRate(){

        if (balance <= STAGE1) {
            RATE = 750;
            currentStage = STAGE2;
        }
        else if (balance <= STAGE2) {
            RATE = 500;
            currentStage = STAGE3;
        }
        else if (balance <= STAGE3) {
            RATE = 250;
            currentStage = STAGE4;
        }
    }


    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount.div(10 ** 18).mul(RATE);
    }

    function check(address cheking, uint256 amount) public returns (bool){
        if (topAmount.sub(accountBalances[cheking] + amount) > 0) {
            return true;
        } else {
            return false;
        }
    }

    function() public payable {

        if (whitelist[msg.sender]) {
            uint256 weiAmnt = msg.value;
            uint256 _amount = _getTokenAmount(weiAmnt);

            if (balance - _amount > 0) {
                if (check(msg.sender, _amount)) {
                    if (!checkStage(_amount)) {
                        balance = balance - _amount;
                        accountBalances[msg.sender] += _amount;
                        token.transfer(msg.sender, _amount);

                    } else {

                        remainingStage = balance - currentStage;
                        balance = balance - remainingStage;
                        newStage = weiAmnt.div(10 ** 18) - (remainingStage / RATE);
                        setRate();
                        extraAmount = newStage * RATE;
                        uint256 _newAmount = extraAmount + remainingStage;
                        balance = balance - extraAmount;
                        accountBalances[msg.sender] += _newAmount;
                        token.transfer(msg.sender, _newAmount);
                    }
                }
            }
        }
    }
}