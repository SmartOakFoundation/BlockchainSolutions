pragma solidity ^0.4.23;

import "./SmartOakMintable.sol";

contract NeuronGold is SmartOakMintable {

    string public symbol = "NGLD";
    string public name = "Neuron Gold";
    uint8 public decimals = 10;
    uint256 public startTime ;
	address public crowdsaleAddress;
	address public fundationAddress;
	uint256 public tokensCreated;
	uint256 public constant TOKEN_TOTAL_AMOUNT = 10**18;
	uint256 public constant TOKEN_INITIAL_AMOUNT = 10**17;
	uint256 public constant DIVIDER = 200;

	//every stage of crowdsale takes a week
	uint256 public constant NUMBER_OF_SECONDR_IN_A_WEEK = 7*24*3600;
	uint256 public weekFunded = 0;

	constructor(address _crowdsaleAddress,address _fundationAddress) public {
		crowdsaleAddress = _crowdsaleAddress;
		fundationAddress = _fundationAddress;
		tokensCreated = now;
	}
	
    function burn(uint256 amount) public {
		_burn(msg.sender,amount);
    }
}
