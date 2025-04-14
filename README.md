# Staking Smart Contract

A simple and secure staking contract for ERC20 tokens, designed to support delayed unstaking with a 7-day unlock period. Intended to be used in systems where voting power or governance is based on staked token amounts.

---

## 📌 What is it for?

`StakingGigaWei` allows users to stake an ERC20 token (such as GigaWei) and later request to unstake their funds. It introduces a 7-day delay period before users can claim their unstaked tokens, helping align economic incentives and discourage rapid stake-unstake behavior, often critical in governance systems.

This contract can integrate with governance modules that read staked balances to assign voting power.

---

## ⚙️ How does it work?

### ➕ Stake

- Users call `stake(amount)` to lock their tokens in the contract.
- Tokens are transferred from the user's wallet to the contract.
- Internal record is updated with total staked amount and timestamp.

### 🕓 Request Unstake

- Users call `requestUnstake(amount)` to initiate an unstaking request.
- Requested amount is subtracted from their active stake.
- A timestamped unstake request is recorded in a mapping with a unique index.

### ✅ Claim

- After 7 days, users call `claim()` to retrieve any tokens eligible for release.
- The contract loops through the unstake requests and transfers tokens that have passed the 7-day delay.

---

## ✨ Key Features

- ⏳ **7-Day Unlock Period**: Unstake requests are subject to a delay before claiming.
- 🔒 **Secure Accounting**: Stake and unstake amounts are tracked per user.
- 📈 **View Functions**:
  - `stakedBalance(address)` — view current active stake.
  - `claimable(address)` — view claimable amount after unlock period.
- 📤 **Non-custodial**: Users must explicitly call `claim()` to retrieve their tokens.
- 🧩 **Governance Integration Ready**: Compatible with systems that fetch stake balance for voting.

---
