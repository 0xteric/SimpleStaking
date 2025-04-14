// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract StakingGigaWei is Ownable {
    ERC20 public stakingToken;

    struct Stake {
        uint amount;
        uint timestamp;
    }

    struct UnstakeRequest {
        uint amount;
        uint timestamp;
    }

    mapping(address => Stake) public stakes;
    mapping(address => mapping(uint => UnstakeRequest)) public unstakes;
    mapping(address => uint) public unstakeCount;

    event Staked(address indexed _user, uint _amount);
    event UnstakeRequested(address indexed _user, uint amount);
    event Unstaked(address indexed _user, uint amount);

    constructor(address _govToken, address _owner) Ownable(_owner) {
        stakingToken = ERC20(_govToken);
    }

    function stake(uint amount) external {
        stakingToken.transferFrom(msg.sender, address(this), amount);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function requestUnstake(uint amount) external {
        require(
            stakes[msg.sender].amount >= amount,
            "Insufficient balance staked."
        );

        stakes[msg.sender].amount -= amount;

        unstakes[msg.sender][unstakeCount[msg.sender]] = UnstakeRequest({
            amount: amount,
            timestamp: block.timestamp
        });

        unstakeCount[msg.sender] += 1;

        emit UnstakeRequested(msg.sender, amount);
    }

    function claim() public returns (uint) {
        uint amountClaimable = 0;
        for (uint i = 0; i <= unstakeCount[msg.sender]; i++) {
            if (block.timestamp - unstakes[msg.sender][i].timestamp >= 7 days) {
                amountClaimable += unstakes[msg.sender][i].amount;
                delete (unstakes[msg.sender][i]);
            }
        }
        stakingToken.transfer(msg.sender, amountClaimable);

        emit Unstaked(msg.sender, amountClaimable);
        return amountClaimable;
    }

    function stakedBalance(address _user) public view returns (uint) {
        return stakes[_user].amount;
    }

    function claimable(address _user) public view returns (uint) {
        uint amountClaimable = 0;
        for (uint i = 0; i <= unstakeCount[_user]; i++) {
            if (block.timestamp - unstakes[_user][i].timestamp >= 7 days) {
                amountClaimable += unstakes[_user][i].amount;
            }
        }
        return amountClaimable;
    }
}
