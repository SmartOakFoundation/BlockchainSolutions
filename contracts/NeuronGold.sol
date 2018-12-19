pragma solidity >=0.4.22 <0.6.0;
import "./SmartOakMintable.sol";


contract NeuronGold is SmartOakMintable {

    string public symbol = "NGLD";
    string public name = "Neuron Gold";
    uint8 public decimals = 10;
    uint256 public startTime = 0;
    address public emmiterAddress;
    uint256 public tokensCreated;

    function NeuronGold(address _emmiterAddress, uint256 totalAmount) public {
        emmiterAddress = _emmiterAddress;
        tokensCreated = now;
        mint(_emmiterAddress, totalAmount);
    }
    
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
