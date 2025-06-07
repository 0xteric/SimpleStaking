# StakingGigaWei

A simple ERC20 staking smart contract with delayed unstaking and claim functionality.

## Overview

`StakingGigaWei` allows users to stake an ERC20 token and request to unstake later. The withdrawal (claim) is only possible after a 7-day waiting period from the time of the unstake request.

## Features

- ✅ Stake any ERC20 token (set during deployment)
- 🕒 Unstaking requires a 7-day cooldown
- 📥 Multiple unstake requests can be managed per user
- 🔐 Only the owner (set at deployment) can manage contract ownership

## Functions

### `constructor(address _govToken, address _owner)`
Initializes the staking token and sets the owner.

### `stake(uint amount)`
Transfers tokens from the user to the contract and updates their stake.

### `requestUnstake(uint amount)`
Subtracts tokens from the user’s stake and logs an unstake request with a timestamp.

### `claim()`
Transfers all eligible tokens (after 7 days) from unstake requests back to the user.

### `stakedBalance(address _user)`
Returns the amount a user has currently staked.

### `claimable(address _user)`
Returns the amount a user can currently claim from completed unstake cooldowns.

## Events

- `Staked(address user, uint amount)`
- `UnstakeRequested(address user, uint amount)`
- `Unstaked(address user, uint amount)`

## Notes

- Users must first `stake()`, then `requestUnstake()`, and finally `claim()` after 7 days to retrieve tokens.
- Make sure the staking token has `approve()` called before staking.

## License

MIT

