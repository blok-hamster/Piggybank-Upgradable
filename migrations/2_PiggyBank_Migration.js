const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const PiggyBank = artifacts.require("PiggyBank");

module.exports = async function (deployer, network, accounts) {
  const instance = await deployProxy(PiggyBank, [accounts[0]], { deployer });
  console.log('Deployed', instance.address);
};



/*
const PiggyBank = artifacts.require("PiggyBank");
const PiggyBankRouter = artifacts.require("PiggyBankRouter");
const PiggyBankV2 = artifacts.require("PiggyBankV2");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(PiggyBank);
  await deployer.deploy(PiggyBankRouter, PiggyBank.address);
  
  let piggyBank = await PiggyBank.deployed()
  let pig = await PiggyBankRouter.deployed()
   
  let pigRouter = await PiggyBank.at(pig.address);
  await pigRouter.depositEth({value: 1});
  
  let balance = await pigRouter.getBalance(web3.utils.fromUtf8("ETH"));
  console.log("Before Update: " + balance.toNumber());
  
  await pigRouter.withdrawEth(1);
  await pigRouter.depositEth({value: 10});
  balance = await pigRouter.getBalance(web3.utils.fromUtf8("ETH")); 
  console.log(balance.toNumber());

  await deployer.deploy(PiggyBankV2);
  
  let piggybankV2 = await PiggyBankV2.deployed()
  
  pigRouter = await PiggyBankV2.at(pig.address);
  //await pigRouter.depositEth({value: 10});

  let newBalance = await pigRouter.getBalance(web3.utils.fromUtf8("ETH"));
  console.log(newBalance.toNumber());


};*/
