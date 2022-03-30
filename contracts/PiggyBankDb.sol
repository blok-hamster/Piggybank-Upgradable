// SPDX-License-Identifier: MIT
pragma solidity >=0.5.1 <0.8.12; 

contract PiggyBankDb {

    enum Lock{
        ONE,
        TWO,
        THREE
    }

    mapping(address => mapping(bytes32 => uint)) tokenBalance;
    mapping(bytes32 => Tokens) tokenMap;
    mapping(address => mapping(bytes32 => uint)) lockedTokenBalance;
    mapping(address => mapping(uint => LockFunds[])) lockedFunds;
    
    struct Tokens{
        address tokenAddress;
        bytes32 symbol;
    }

    struct LockFunds{
        address fundOwner;
        bytes32 Symbol;
        uint amount;
        uint startTime;
        uint lockPeriod;
        uint id;
        Lock lockOption;
    }
    
    bytes32[] tokenList;
    uint txId;
    
    address public owner;
    bool public _initialized;

    mapping (string => uint256) _uintStorage;
    mapping (string => address) _addressStorage;
    mapping (string => bool) _boolStorage;
    mapping (string => string) _stringStorage;
    mapping (string => bytes4) _bytesStorage;
    mapping (string => bytes32) _bytes32Storage;

}