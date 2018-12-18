const NeuronCash = artifacts.require('NeuronCash');
const NeuronGold = artifacts.require('NeuronGold');


var assertRevert = async function (promise) {

    try {
        await promise;
        assert.fail('Expected revert not received');
    } catch (error) {
        const revertFound = error.message.search('revert') >= 0;
        assert(revertFound, `Expected "revert", got ${error} instead`);
    }
}

contract('NeuronCash', function ([ownerAddr, crowdsaleAddress, foundationAddress]) {
    var data = {};

    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';
    beforeEach(async function () {
        console.log("Cash creating...");
        data.cash = await NeuronCash.new(foundationAddress);
        console.log("Gold creating...");
        data.gold = await NeuronGold.new(crowdsaleAddress, foundationAddress);
        console.log("GoCash initializer...", ownerAddr, data.cash.address);
        await web3.eth.sendTransaction({
            from: ownerAddr,
            to: data.cash.address,
            value: 0
        });
    });

    describe('foundationAddress', function () {
        it('should have non zero balance', async function () {
            var balance = await data.cash.balanceOf(foundationAddress);
            assert.isTrue(balance > 0);
        });
    });

});