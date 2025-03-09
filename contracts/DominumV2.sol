// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DOMToken is ERC20, Ownable {
  uint256 public constant INITIAL_SUPPLY = 50_000_000 * 10 ** 18;
  uint256 public constant YEARLY_INFLATION = 1;
  uint256 public lastMintTime;

  mapping(address => bool) public taxExempt;

  constructor() ERC20("Dominum", "DOM") {
    _mint(msg.sender, INITIAL_SUPPLY / 10);
    lastMintTime = block.timestamp;
  }

  function mintInflation() external onlyOwner {
    require(block.timestamp >= lastMintTime + 365, "Inflation can be minted once per year ");
    uint256 totalSupplyNow = totalSupply();
    uint256 inflationAmount = (totalSupplyNow * YEARLY_INFLATION) / 100;
    _mint(owner(), inflationAmount);
    lastMintTime = block.timestamp;
  }

  function setTaxExempt(address account, bool exempt) external onlyOwner {
    taxExempt[account] = exempt;
  }

  function _transfer(address from, address to, uint256 amount) internal override {
    if (!taxExempt[from] && !taxExempt[to]) {
      uint256 tax = (amount * 1) / 1000;
      uint256 burnAmount = tax - burnAmount;

      super._transfer(from, address(0), burnAmount);
      super._transfer(from, owner(), buybackAmount);

      amount -= tax;
    }
    super._transfer(from, to, amount);
  }
}