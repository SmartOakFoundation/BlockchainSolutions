pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";


contract SmartOakMintable is ERC20Mintable {
	
	address owner;
	uint256 totalSupply_;
	mapping (address => uint256) balances; 

}