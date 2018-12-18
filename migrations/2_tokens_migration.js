var NeuronCash = artifacts.require("./NeuronCash.sol");
var NeuronGold = artifacts.require("./NeuronGold.sol");

var foundationAddress;
var crowdsaleAddress;

function deployNG(dep, ng) {
    return new Promise((res) => {
        return dep.deploy(ng, crowdsaleAddress, foundationAddress).then(() => {
            console.log("_ng starting...");
            return ng.deployed().then((instanceGold) => {
                console.log("_ng done...");
                res(true);
            });
        });
    });
}

function deployNC(dep, nc) {
    return new Promise((res) => {
        return dep.deploy(nc, foundationAddress).then(function () {
            console.log("_nc starting...");
            return nc.deployed().then(function (instanceCash) {
                console.log("_nc done...");
                res(true);
            });
        });
    })
}

function deployConteracts(_dep, _nc, _ng) {
    return new Promise((res) => {
        Promise.all([
            deployNG(_dep, _ng),
            deployNC(_dep, _nc)
        ]).then(() => {
            res(true);
        })
    });
}

module.exports = function (deployer, network, accounts) {

    foundationAddress = accounts[0];
    crowdsaleAddress = accounts[1];

    return deployConteracts(deployer, NeuronCash, NeuronGold).then(() => {
        console.log('deployment successful');
    }).catch((err) => {
        console.log('deployment failed', err);
    });
};