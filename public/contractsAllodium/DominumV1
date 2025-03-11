// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dominum is ERC20, Ownable {
  uint256 public constant INITIAL_SUPPLY = 100_000_000 * 10 ** 4;
  uint256 public constant INITIAL_UNLOCKED = 10_000_000 * 10 ** 4;
  uint256 public constant YEARLY_UNLOCK_PERCENT = 30;
  uint256 public constant INFLATION_RATE = 1;
  uint256 public TRANSACTION_TAX = 1; // 0.01%

  uint256 public lastInflationTime;
  uint256 public lockedTokes;
  uint256 public unlockedTokens;
  address public buybackContract;

  mapping(address => bool) private taxExempt;

  constructor(address _buybackContract) ERC20("Dominum", "DOM") {
    require(_buybackContract != address(0), "Invalid buyback contract address");
    buybackContract = _buybackContract;

    _mint(msg.sender, INITIAL_UNLOCKED);
    lockedTokens = INITIAL_SUPPLY - INITIAL_UNLOCKED;
    lastInflationTime = block.timestamp;

    taxExempt[msg.sender] = true;
    taxExempt[address(this)] = true;
    taxExempt[_buybackContract] = true;
  }

  function unlockTokens() external onlyOwner {
    require(lockedTokens > 0, "No lockd tokens left");
    uint256 amountToUnlock = (lockedTokens * YEARLY_UNLOCK_PERCENT) / 100;
    
    if (amountToUnlock > lockedTokens) {
      amountToUnlock = lockedTokens;
    }

    lockedTokens -= amountToUnlock;
    _mint(msg.sender, amountToUnlock);
  }

  function calculateInflation() external onlyOwner {
    require(block.timestamp >= lastInflationTime + 365 days, "Inflaion once per year");

    uint256 circulatingSupply = totalSupply() - lockedTokens;
    uint256 inflationokens = (circulatingSupply * INFLATION_RATE) / 100;

    _mint(address(this), inflationTokens);
    lastInflationTime = block.timestamp;
  }

  function _transfer(address sender, address recipient, uint256 amount) internal override {
    if (taxExempt[sender] || taxExempt[recipient]) {
      super._transfer(sender, recipient, amount);
    } else {
      uint256 taxAmount = (amount * TRANSACTION_TAX) / 10_000;
      uint256 burnAmount = taxAmount / 2;
      uint256 buybackAmount = taxAmount - burnAmount;
      uint256 transferAmount = amount - taxAmount;

      _burn(sender, burnAmount);
      super._transfer(sender, buybackContract, buybackAmount);
      super._transfer(sender, recipient, transferAmount);
    }
  }

  function setBuybackContract(address _buybackContract) external onlyOwner {
    require(_baybackContract != address(0), "Invalid address");
    buybackContract = _buybackContract;
    taxExempt[_buybackContract] = true;
  }

  function addTaxExemption(address account) external onlyOwner {
    taxExempt[account] = true;
  }

  receive() external payable {}
  
}

