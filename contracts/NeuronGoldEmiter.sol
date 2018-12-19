pragma solidity >=0.4.22 <0.6.0;
import "./NeuronCash.sol";

/*
Contract holding all unemited Neuron Gold
responsible for checking velocity of neuron 
Cash and adjustment of speed of emition for NeuronGold
*/

contract NeuronGoldEmiter {

    NeuronCash neuronCash;
    ERC20 neuronGold;
    address crowdsale;
    
    //every stage of crowdsale takes a week
    uint256 public constant NUMBER_OF_SECONDR_IN_A_WEEK = 7*24*3600;
    uint256 public weekFunded = 0;
    uint256 public emiterCreation;
    uint256 public constant DIVIDER = 325;
    uint256 public baseSpeed;
    uint256 public constant BASE_SPEED_MODIFFIER = 1000000;

    function NeuronGoldEmiter(address _neuronGold, NeuronCash _neuronCash, address _crowdsale) public {
        neuronCash = _neuronCash;
        neuronGold = ERC20(_neuronGold);
        emiterCreation = now;
        crowdsale = _crowdsale;
        baseSpeed = neuronCash.getSpeed();
    }

    function () public {
        uint256 spendableBalance = neuronGold.balanceOf(address(this));
        uint256 currentWeek = (now-emiterCreation)/NUMBER_OF_SECONDR_IN_A_WEEK ;
        if (currentWeek != weekFunded) {
            weekFunded = currentWeek;
            uint256 speedModifier = getCurrentNeuronCashSpeed();
            neuronGold.transfer(crowdsale, spendableBalance/DIVIDER*speedModifier/BASE_SPEED_MODIFFIER);
        }
    }

    function getCurrentNeuronCashSpeed() public returns(uint256) {
        uint256 speed = neuronCash.getSpeed();
        return speed*BASE_SPEED_MODIFFIER/baseSpeed;
    }
}