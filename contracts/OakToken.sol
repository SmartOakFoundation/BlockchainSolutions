pragma solidity ^0.4.23;
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';



contract OakToken is MintableToken{

    string public symbol = "OAK";
    string public name = "Oak Token";
    uint8 public decimals = 0;
	address public fundationAddress;
	uint8 public yearlyInflationRate;
	uint256 publictimeTokenStarted;
	uint256 timeTokenStarted;
	uint256 public tokensCreated;
	uint256 public constant TOKEN_INITIAL_AMOUNT = 10**8;
	uint256 public constant NUMBER_OF_SECONDR_IN_A_YEAR = 365*24*3600;
	constructor(address _foundationAddress) public {
		fundationAddress = _foundationAddress;
		owner = address(this);
		timeTokenStarted = now;
	}
	
	function init(){
		require(totalSupply()==0);
		this.mint(fundationAddress,TOKEN_INITIAL_AMOUNT);
	}
	
	
	function () {
		uint256 _timePassedSinceCreated = now - tokensCreated;
		uint256 newTokensAmount = _timePassedSinceCreated*TOKEN_INITIAL_AMOUNT/100*yearlyInflationRate/NUMBER_OF_SECONDR_IN_A_YEAR;
		this.mint(fundationAddress,newTokensAmount-tokensCreated);
	}
	
	
    function burn(uint256 amount) public {
        require(balanceOf(msg.sender)>=amount);
        totalSupply_ = totalSupply_.sub(amount);
        balances[msg.sender] = balances[msg.sender].sub(amount);
		emit Transfer(msg.sender,address(0),amount);
    }
}
