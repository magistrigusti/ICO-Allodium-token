// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BuybackAndStaking is Ownable {
  IERC20 public domToken;
  uint256 public rewardPool;
  uint256 public totalStaked;

  struct Stake {
    uint256 amount;
    uint256 lastClaim;
  }

  mapping(address => Stake) public stakes;

  constructor(address _domToken) {
    domToken = IERC20(_domToken);
  }

  function depositBuyback(uint256 amount) external onlyOwner {
    domToken.transferFrom(msg.sender, address(this), amount);
    rewardPool += amount;
  }

  function stake(uint256 amount) external {
    require(amount > 0, "Cannot stake zero");
    domToken.transferFrom(msg.sender, address(this), amount);
    stakes[msg.sender].amount += amount;
    stakes[msg.sender].lastClaim = block.timestamp;
    totalStaked += amount;
  }

  function claimRewards() external{
    require(stakes[msg.sender].amount > 0, "No staked tokens");
    uint256 reward = alculateReward(msg.sender);
    stakes[msg.sender].lastClaim = block.timestamp;
    domToken.transfer(msg.sender, reward);
  }

  function calculateReward(address user) public view returns (uint256) {
    uint256 userStake = stakes[user].amount;
    uint256 timeStaked = block.timestamp - stakes[user].lastClaim;
    return (rewardPool * userStae * timeStaked) / (totalStaked * 365 days);
  }

  function withdrawStake() external {
    require(stakes[msg.sender].amount > 0, "Nothing to withdraw");
    require(block.timestamp - stakes[msg.sender].lastClaim >= 7 days, "Must wait 7 days");
    uint256 amount = stakes[msg.sender].amount;
    stakes[msg.sender].amount = 0;
    totalStaked -= amount;
    domToken.transfer(msg.sender, amount);
  }
}