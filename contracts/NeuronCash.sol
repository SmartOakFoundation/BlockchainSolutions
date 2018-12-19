pragma solidity >=0.4.22 <0.6.0;
import "./SmartOakMintable.sol";


contract NeuronCash is SmartOakMintable {

    struct Velocity {
        uint32 lastUpdateTime;
        uint192 velocity;
        uint32 updateCount;
    }

    string public symbol = "NCH";
    string public name = "Neuron  Cash";
    uint8 public decimals = 0;
    address public fundationAddress;
    uint256 public tokensCreated;
    Velocity public velocity;
    uint256 public constant TOKEN_INITIAL_AMOUNT = 10**10;
    uint256 public constant NUMBER_OF_SECONDS_IN_A_MONTH = 30*24*3600;
    mapping (address=>uint256 ) public lastTimeTaxPayed;

    function NeuronCash(address _foundationAddress) public {
        fundationAddress = _foundationAddress;
        tokensCreated = now;
        velocity.lastUpdateTime = uint32(now);
    }

    function getSpeed() public view returns(uint256) {
        return uint256(velocity.velocity);
    }

    function () public {
        if (totalSupply() > 0) {
            updateVelocity();
        }
        mint(fundationAddress, TOKEN_INITIAL_AMOUNT-totalSupply());
        if (lastTimeTaxPayed[fundationAddress] == 0) {
            uint256 periodsCount = (now-tokensCreated)/NUMBER_OF_SECONDS_IN_A_MONTH;
            lastTimeTaxPayed[fundationAddress] = periodsCount*NUMBER_OF_SECONDS_IN_A_MONTH;
        }
    }

    function updateVelocity() public {
        if (now > velocity.lastUpdateTime) {
            uint256 newAmount = TOKEN_INITIAL_AMOUNT-totalSupply();
            newAmount = newAmount*(NUMBER_OF_SECONDS_IN_A_MONTH/(now - velocity.lastUpdateTime));
            velocity.updateCount = velocity.updateCount+1;
            velocity.lastUpdateTime = uint32(now);
            uint32 multipl = velocity.updateCount+2;
            if (multipl > 999) {
                multipl = 999;
            }
            velocity.velocity = uint192((velocity.velocity*multipl+newAmount)/(multipl+1));
            //expotential moving average
        }
    }
    
    function burn(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
    }

    function daysToTaxation(address user) public view returns(uint256) {
        if (now > lastTimeTaxPayed[user] && now - lastTimeTaxPayed[user] > NUMBER_OF_SECONDS_IN_A_MONTH) {
            return 0;
        } else {
            return now - lastTimeTaxPayed[user];
        }
    }
    
    /*
      1% of users balance per month

      zmieni� z liniowego na schodkowy
    */
    function getTaxInfo(address user) public view returns(uint256 amountOfTax, uint256 daysToTax) {
        return (getTaxAmount(user), daysToTaxation(user));
    }

    function  balanceOf(address user) public view returns(uint256) {
        return super.balanceOf(user)-getTaxAmount(user);
    } 
        
    function transfer(address _to, uint256 _value) public returns(bool) {
        setupAccount(_to, msg.sender);
        burnUsersFunds(getTaxAmount(msg.sender), msg.sender);
        burnUsersFunds(getTaxAmount(_to), _to);
        return super.transfer(_to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        setupAccount(_to, _from);
        burnUsersFunds(getTaxAmount(msg.sender), msg.sender);
        burnUsersFunds(getTaxAmount(_to), _to);
        burnUsersFunds(getTaxAmount(_from), _from);
        return super.transferFrom(_from, _to, _value);
    }

    function setupAccount(address user, address _from) private {
        if (lastTimeTaxPayed[user] == 0) {
            lastTimeTaxPayed[user] = lastTimeTaxPayed[_from];
        }
    }

    function burnUsersFunds(uint256 amount, address person) private {
        if (amount > 0) {
            _burn(person, amount);
        }
        lastTimeTaxPayed[person] = ((now-tokensCreated)/NUMBER_OF_SECONDS_IN_A_MONTH)*NUMBER_OF_SECONDS_IN_A_MONTH;
    }

    function getTaxAmount(address user) private view returns(uint256) {
        if (daysToTaxation(user) > 0 || user == fundationAddress) { 
            return 0;
        } else { //now > lastTimeTaxPayed[user] due to daysToTaxation
            uint256 periodsCount = (now-lastTimeTaxPayed[user])/NUMBER_OF_SECONDS_IN_A_MONTH;
            return super.balanceOf(user)-getAmount(super.balanceOf(user), periodsCount);
        }
        return super.balanceOf(user).div(100);
    }

    function getAmount(uint256 _base, uint256 rounds) private pure returns(uint256) {
/*
 one round per month, this should not be a problem for long time, 
 anyone can make account recomputing for a user by making transfer
*/
        uint256 tmp = _base;
        for (uint256 i = 0; i < rounds; i++) {
            tmp = tmp.div(100).mul(99);
        }
        return tmp;
    }
}
