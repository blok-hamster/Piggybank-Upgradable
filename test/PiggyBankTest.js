const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const PiggyBank = artifacts.require('PiggyBank');
const truffleAssert = require('truffle-assertions');

contract('upgrades', accounts => {
  it('works', async () => {
    let piggyBank = await deployProxy(PiggyBank, [accounts[0]]);
    
    let balance = await piggyBank.getBalance(web3.utils.fromUtf8("ETH"));
    await piggyBank.depositEth({value: 10});
    truffleAssert.passes(
        balance.toString(), '10'
    );
  });

  it('works', async () => {
    let piggyBank = await deployProxy(PiggyBank, [accounts[0]]);
    
    await piggyBank.depositEth({value: 10});
    await piggyBank.withdrawEth(10);
    let balance = await piggyBank.getBalance(web3.utils.fromUtf8("ETH"));
    truffleAssert.passes(
        balance.toString(), '0'
    );
  });

});