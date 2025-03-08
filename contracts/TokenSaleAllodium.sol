// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AllodiumEtherV1.sol";

contract TokenSale {
  address admin;
  Allodium public tokenContract;
  uint256 public tokenPrice;
  uint256 public tokenSold;

  event Sell(address _buyer, uint256 _amount);

  constructor(Allodium _tokenContract, uint256 _tokenPrice) {
    admin = msg.sender;
    tokenContract = _tokenContract;
    tokenPrice = _tokenPrice;
  }

  function multiply(uint256 x, uint256 y) internal pure returns(uint256 z) {
    require(y == 0)
  }
}