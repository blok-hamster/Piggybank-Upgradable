// SPDX-License-Identifier: MIT
pragma solidity >=0.5.1 <0.8.12;
pragma experimental ABIEncoderV2;

import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./PiggyBankDb.sol";

contract Wallet is Initializable, PiggyBankDb {
    using SafeMathUpgradeable for uint;
    
    event TokenAdded(address, bytes32);
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier tokenExist(bytes32 symbol){
        require(tokenMap[symbol].tokenAddress != address(0), "Not a valid token");
        _;
    }

    function initialize(address _owner) public initializer{
        owner = _owner;
        _initialized = true;
    }

    function addToken(address tokenAddress, bytes32 symbol) external onlyOwner(){
        require(tokenAddress != address(0), "Invalid Token Address");
        tokenMap[symbol] = Tokens(tokenAddress, symbol);
        tokenList.push(symbol);
    }

    function depositToken(bytes32 symbol, uint _amount) external tokenExist(symbol) {
        tokenBalance[msg.sender][symbol] = tokenBalance[msg.sender][symbol].add(_amount);
        IERC20Upgradeable(tokenMap[symbol].tokenAddress).transferFrom(msg.sender, address(this), _amount);
    }

    function approveDeposit(uint amount, bytes32 symbol) external {
        IERC20Upgradeable(tokenMap[symbol].tokenAddress).approve(address(this), amount);
    }
    
    function withdrawToken(uint _amount, bytes32 symbol) public tokenExist(symbol) {
        require(tokenBalance[msg.sender][symbol] >= _amount, "Balance Not Sufficent");
        tokenBalance[msg.sender][symbol] = tokenBalance[msg.sender][symbol].sub(_amount);
        IERC20Upgradeable(tokenMap[symbol].tokenAddress).transfer(msg.sender, _amount);
    }

    function depositEth () external payable {
        tokenBalance[msg.sender][bytes32("ETH")] = tokenBalance[msg.sender][bytes32("ETH")].add(msg.value);
    }

    function withdrawEth (uint _amount) external returns(bool success){
        require(tokenBalance[msg.sender][bytes32("ETH")] >= _amount);
        tokenBalance[msg.sender][bytes32("ETH")] = tokenBalance[msg.sender][bytes32("ETH")].sub(_amount);
        msg.sender.call{value: _amount};
        return success;
    }

    function getBalance(bytes32 symbol) public view virtual returns(uint){
        return tokenBalance[msg.sender][symbol];
    }


}




