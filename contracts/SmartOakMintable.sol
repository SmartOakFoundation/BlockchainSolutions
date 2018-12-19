pragma solidity >=0.4.22 <0.6.0;
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract SmartOakMintable is ERC20Mintable, Ownable {
    
    function recoverEther() public onlyOwner{
        owner().transfer(address(this).balance);
    }

    function recoverTokens(address _token) public onlyOwner{
        ERC20(_token).transfer(owner(), ERC20(_token).balanceOf(address(this)));
    }
}