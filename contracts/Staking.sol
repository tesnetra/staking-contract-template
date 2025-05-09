// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Staking {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewardDebt;

    uint256 public rewardRate = 1; // Reward rate per block (can be customized)

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    // Stake function: Allows users to stake their tokens
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        
        // Transfer staking tokens from user to contract
        stakingToken.transferFrom(msg.sender, address(this), amount);
        
        // Update staking balance
        stakes[msg.sender] += amount;
        rewardDebt[msg.sender] = stakes[msg.sender] * rewardRate; // Calculate reward debt
    }

    // Withdraw function: Allows users to withdraw their staked tokens
    function withdraw(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "Insufficient staked balance");

        // Update staking balance
        stakes[msg.sender] -= amount;
        rewardDebt[msg.sender] = stakes[msg.sender] * rewardRate;

        // Transfer tokens back to the user
        stakingToken.transfer(msg.sender, amount);
    }

    // Claim reward function: Allows users to claim their accumulated rewards
    function claimReward() external {
        uint256 reward = stakes[msg.sender] * rewardRate - rewardDebt[msg.sender];
        require(reward > 0, "No reward available");

        // Transfer reward tokens to user
        rewardToken.transfer(msg.sender, reward);

        // Reset reward debt
        rewardDebt[msg.sender] = stakes[msg.sender] * rewardRate;
    }

    // Get the total staked balance of the contract
    function totalStaked() external view returns (uint256) {
        return stakingToken.balanceOf(address(this));
    }
}

