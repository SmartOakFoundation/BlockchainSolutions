var NeuronCash = artifacts.require("./NeuronCash.sol");
var NeuronGold = artifacts.require("./NeuronGold.sol");
var NeuronGoldEmiter = artifacts.require("./NeuronGoldEmiter.sol");

var foundationAddress;
var crowdsaleAddress;
var neuronCashAddress;
var neuronGoldAddress;
var neuronGoldEmiterAddress;
var goldAmount = "22700" + "0000000000";

function initEmiter(nge) {
  return new Promise(res => {
    return nge.init(neuronGoldAddress).then(() => {
      res(true);
    });
  });
}

function deployNGE(dep, ng) {
  return new Promise(res => {
    return dep.deploy(ng, neuronCashAddress, crowdsaleAddress).then(() => {
      console.log("NeuronGoldEmiter starting...");
      return ng.deployed().then(instanceGoldEmiter => {
        neuronGoldEmiterAddress = instanceGoldEmiter.address;
        console.log("_nge done...");
        res(true);
      });
    });
  });
}

function deployNG(dep, ng) {
  return new Promise(res => {
    return dep.deploy(ng, neuronGoldEmiterAddress, goldAmount).then(() => {
      console.log("_ng starting...");
      return ng.deployed().then(instanceGold => {
        neuronGoldAddress = instanceGold.address;
        console.log("_ng done...");
        res(true);
      });
    });
  });
}

function deployNC(dep, nc) {
  return new Promise(res => {
    dep.deploy(nc, foundationAddress).then(function() {
      console.log("_nc starting...");
      nc.deployed().then(function(instanceCash) {
        neuronCashAddress = instanceCash.address;
        console.log("_nc done...");
        res(true);
      });
    });
  });
}

function deployConteracts(_dep, _nc, _ng, _nge) {
  return new Promise(res => {
    return deployNC(_dep, _nc).then(() => {
      console.log("deployNGE starting...");
      return deployNGE(_dep, _nge).then(() => {
        console.log("deployNG starting...");
        return deployNG(_dep, _ng).then(() => {
          console.log("deployNG ended...");
          res(true);
        });
      });
    });
  });
}

module.exports = function(deployer, network, accounts) {
  foundationAddress = accounts[0];
  crowdsaleAddress = accounts[1];

  deployer.then(() => {
    return new Promise((res, rej) => {
      deployConteracts(deployer, NeuronCash, NeuronGold, NeuronGoldEmiter)
        .then(() => {
          console.log("deployment successful");
          res(true);
        })
        .catch(err => {
          console.log("deployment failed", err);
          rej(err);
        });
    });
  });
};
