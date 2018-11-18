pragma solidity ^0.4.23;
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';



contract NeuronGold is MintableToken{

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
		owner = address(this);
	}
	
	function init(){
		require(totalSupply()==0);
		this.mint(fundationAddress,TOKEN_INITIAL_AMOUNT);
	}
	
	
	function generateNew() public{
		uint256 weekComputed = (now - tokensCreated)/NUMBER_OF_SECONDR_IN_A_WEEK;
		if(weekComputed!=weekFunded){ // max once per week can mint portion for next round of crowdsale 
			weekFunded = weekComputed;
			this.mint(crowdsaleAddress,(TOKEN_TOTAL_AMOUNT-totalSupply()/DIVIDER));
		}
	}
	
	
    function burn(uint256 amount) public {
        require(balanceOf(msg.sender)>=amount);
        totalSupply_ = totalSupply_.sub(amount);
        balances[msg.sender] = balances[msg.sender].sub(amount);
		emit Transfer(msg.sender,address(0),amount);
    }
}
