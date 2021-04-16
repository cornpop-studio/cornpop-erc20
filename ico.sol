pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./token.sol";


contract CornpopIco {
    uint balance = 750000;
    address owner;
    mapping(address => bool) whitelist;
    uint256 public whitelistedNumber = 0;
    uint STAGE0 = 750000;
    uint STAGE1 = 500000;
    uint STAGE2 = 250000;
    uint STAGE3 = 100000;
    uint currentStage;

    function CornPopICO(address _tokenAddr) public {
        token = CornPop(_tokenAddr);
        owner = msg.sender;
        currentStage = STAGE0;
    }

    modifier _ownerOnly(){
        require(msg.sender == owner);
        _;
    }
    using SafeMath for uint256;

    CornPop token;

    uint256 public RATE = 1000; // 1 ETH = 1000 CPOP

    function whitelistAddress(address _add) _ownerOnly public payable {
        require(!whitelist[_add], "Candidate must not be whitelisted.");
        whitelist[_add] = true;
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
            currentStage = STAGE1;
        }
        else if (balance <= STAGE2) {
            RATE = 500;
            currentStage = STAGE2;
        }
        else if (balance <= STAGE3) {
            RATE = 250;
            currentStage = STAGE3;
        }
    }


    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount.div(10 ** 18).mul(RATE);
    }

    function() public payable {

        if (whitelist[msg.sender]) {
            uint256 weiAmnt = msg.value;
            uint256 _amount = _getTokenAmount(weiAmnt);
            if (balance - _amount > 0) {
                if (!checkStage(_amount)) {
                    balance = balance - _amount;
                    token.transfer(msg.sender, _amount);

                } else {

                    uint256 remainingStage = balance - currentStage;
                    uint256 newStage = weiAmnt - (remainingStage / RATE);
                    setRate();
                    uint256 _newAmount = _getTokenAmount(newStage) + remainingStage;
                    balance = balance - _newAmount;
                    token.transfer(msg.sender, _newAmount);


                }

            }
        }

    }
}