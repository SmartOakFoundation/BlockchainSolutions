var PwayToken = artifacts.require("./OakToken.sol");


var tokenContract = undefined;
module.exports = function(deployer, network, accounts) {
  var fundationAddress = accounts[0];
  deployer.deploy(PwayToken,fundationAddress).then(function(){
	  PwayToken.deployed().then(function(instance){
		  tokenContract = instance;
		  instance.init().then(function(){
			instance.balanceOf(fundationAddress).then(function(balance){
				console.log("Balance of Foundation ",balance.toString());
			});
		  });;
		  
		  
	  });
	  
  });;
};
