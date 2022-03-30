// SPDX-License-Identifier: MIT
pragma solidity >=0.5.1 <0.8.12;
pragma experimental ABIEncoderV2;

import "./Wallet.sol"; 


contract PiggyBank is Wallet {

    using SafeMathUpgradeable for uint;

    function lockToken (uint _amount, bytes32 _symbol, Lock _lockOption) external returns(bool success){
        require(tokenBalance[msg.sender][_symbol] >= _amount, "Not enough balance");
        LockFunds[] storage newLockFunds = lockedFunds[msg.sender][uint(_lockOption)];
        
        if(_lockOption == Lock.ONE){
            LockFunds(msg.sender, _symbol, _amount, block.timestamp, block.timestamp.add(4 weeks), txId, _lockOption);
            newLockFunds.push(LockFunds(msg.sender, _symbol, _amount, block.timestamp, block.timestamp.add(4 weeks), txId, _lockOption));
        }
        
        else if(_lockOption == Lock.TWO){
            LockFunds(msg.sender, _symbol, _amount, block.timestamp, block.timestamp.add(26 weeks), txId, _lockOption);
            newLockFunds.push(LockFunds(msg.sender, _symbol, _amount, block.timestamp, block.timestamp.add(26 weeks), txId, _lockOption));
        }
       
        else if(_lockOption == Lock.THREE){
            LockFunds(msg.sender, _symbol, _amount, block.timestamp, block.timestamp.add(52 weeks), txId, _lockOption);
            newLockFunds.push(LockFunds(msg.sender, _symbol, _amount, block.timestamp, block.timestamp.add(52 weeks), txId, _lockOption));
        }

        tokenBalance[msg.sender][_symbol] = tokenBalance[msg.sender][_symbol].sub(_amount);
        lockedTokenBalance[msg.sender][_symbol] = lockedTokenBalance[msg.sender][_symbol] + _amount;
        txId++;
        return success;
    }

    function topUp(uint _amount, bytes32 _symbol) external returns(bool success){
        require(lockedTokenBalance[msg.sender][_symbol] >= 0, "Go Lock Some Token");
        lockedTokenBalance[msg.sender][_symbol] = lockedTokenBalance[msg.sender][_symbol].add(_amount);
        return success;
    }

    function withdrawLockedToken(uint _amount, bytes32 _symbol, uint _txId) external returns(bool success){
        LockFunds[] storage newLockFunds = lockedFunds[msg.sender][_txId];
        require(lockedTokenBalance[msg.sender][_symbol] >= _amount);
        require(block.timestamp >= newLockFunds[_txId].lockPeriod);
        require(msg.sender == newLockFunds[_txId].fundOwner);
        lockedTokenBalance[msg.sender][_symbol] = lockedTokenBalance[msg.sender][_symbol].sub(_amount);
        tokenBalance[msg.sender][_symbol] = tokenBalance[msg.sender][_symbol].add(_amount);
        withdrawToken(_amount, _symbol);

        if(lockedTokenBalance[msg.sender][_symbol] == 0 && block.timestamp >= newLockFunds[_txId].lockPeriod){
            for(uint i = _txId; i < newLockFunds.length - 1; i++){
                newLockFunds[i] = newLockFunds[i + 1];
            }
            newLockFunds.pop();
        }

        return success;
    }

    function getLockedTokenBalance(bytes32 symbol) external view returns(uint){
        return lockedTokenBalance[msg.sender][symbol];
    }

    function getLockedFunds(uint _txId) external view returns(LockFunds[] memory){
        return lockedFunds[msg.sender][_txId];
    }

}
