pragma solidity ^0.4.18;

import "./StandardToken.sol";
import "./Ownable.sol";

contract ChainlancersToken is StandardToken, Ownable {

  string public constant NAME = "ChainlancersToken";
  string public constant SYMBOL = "CLT"; 
  uint8 public constant DECIMALS = 18;
  
  uint256 public constant TOKENS_FIRST_PERIOD = 20000; // 100% bonus
  uint256 public constant TOKENS_SECOND_PERIOD = 16000; // 60% bonus
  uint256 public constant TOKENS_THIRD_PERIOD = 14000; // 40% bonus
  uint256 public constant TOKENS_FORTH_PERIOD = 12000; // 20% bonus
  uint256 public constant TOKENS_FIFTH_PERIOD = 10000; // Main Price
   
  uint256 public startDate; // Start of the Crowdsale
  uint256 public firstPeriodEnd; // Pre Sale Period
  uint256 public secondPeriodEnd; // Main Sale First Phase
  uint256 public thirdPeriodEnd; // Main Sale Second Phase
  uint256 public forthPeriodEnd; // Main Sale Third Phase
  uint256 public fifthPeriodEnd; // Main Sale Forth Phase

  uint256 currentPeriod;

  uint256 tokensPerEther;

  uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(DECIMALS)); // 100 MLN tokens initial supply

  event Bought(address indexed _who, uint256 _tokens);
  event CurrentPeriod(uint256 _period, uint256 _tokensPerEther);
  
  function ChainlancersToken() public {
	tokensPerEther = TOKENS_FIRST_PERIOD;
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
	
	startDate = block.timestamp; 
	firstPeriodEnd = startDate + 2 weeks; 
	secondPeriodEnd = firstPeriodEnd + 1 weeks; 
	thirdPeriodEnd = secondPeriodEnd + 1 weeks; 
	forthPeriodEnd = thirdPeriodEnd + 1 weeks; 
	fifthPeriodEnd = forthPeriodEnd + 1 weeks; 
	
	currentPeriod = firstPeriodEnd;
	
    Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }
  
  function privateInvestors () {
	//TODO
  }
  
  function changePeriod() internal {
	if (block.timestamp >= firstPeriodEnd) {
		currentPeriod = secondPeriodEnd;
		tokensPerEther = TOKENS_SECOND_PERIOD;
	} else if (block.timestamp >= secondPeriodEnd) {
		currentPeriod = thirdPeriodEnd;
		tokensPerEther = TOKENS_THIRD_PERIOD;
	} else if (block.timestamp >= thirdPeriodEnd) {
		currentPeriod = forthPeriodEnd;
		tokensPerEther = TOKENS_FORTH_PERIOD;
	} else if (block.timestamp >= forthPeriodEnd) {
		currentPeriod = fifthPeriodEnd;
		tokensPerEther = TOKENS_FIFTH_PERIOD;
	}
	
	CurrentPeriod(currentPeriod, tokensPerEther);
  }
  
  function () public payable {
    require(msg.value > 0);
	
	changePeriod();
	
	uint256 tokens = tokensPerEther * msg.value;
	balances[msg.sender] = balances[msg.sender].add(tokens);
	balances[owner] = balances[owner].sub(tokens);
	totalSupply_ = totalSupply_.sub(tokens);
	
	Bought(msg.sender, tokens);
  }
}