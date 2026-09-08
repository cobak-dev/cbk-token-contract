# cbk-token-contract

Official CBK (Cobak Token) contract sources — the new ERC20 token and the Ethereum swap contract used to migrate from the old CBK token.

> **Status: deployed on Ethereum mainnet, under external audit.**
> The swap is **not yet enabled** — the vault allowance is `0`, so `swap()` reverts. Do not use these addresses for migration until the official announcement.

## Contracts

| Contract | Purpose |
| --- | --- |
| [`CBKToken.sol`](CBKToken.sol) | New CBK ERC20 — immutable, no admin functions. Total supply minted once to the distribution Safe at deployment. |
| [`TokenSwap.sol`](TokenSwap.sol) | Old CBK → new CBK at a fixed 1:1 ratio. Holds swapped-in old tokens forever (no withdrawal path). |

## Token

| Item | Value |
| --- | --- |
| Name | Cobak Token |
| Symbol | CBK |
| Decimals | 18 |
| Total Supply | 100,000,000 CBK |
| Standard | OpenZeppelin ERC20 (immutable, no admin functions) |

## Swap

`TokenSwap` exposes a single state-changing function:

```solidity
function swap(uint256 oldAmount) external nonReentrant;
```

The caller approves `TokenSwap` for `oldAmount` of old CBK, then calls `swap`. The contract:

1. pulls `oldAmount` old CBK from the caller and **locks it permanently** — there is intentionally no withdrawal path, so locked tokens are effectively burned;
2. pays out the same amount of new CBK from the `vault` (a Safe multisig) via its allowance;
3. emits `Swapped(user, oldAmount, newAmount)` with `oldAmount == newAmount`.

The contract holds **no privileged role and no owner**. Its three parameters are `immutable`, fixed at deployment:

| Parameter | Meaning |
| --- | --- |
| `oldToken` | Old CBK token contract |
| `newToken` | New CBK token contract (`CBKToken` above) |
| `vault` | Safe multisig funding new-token payouts |

The vault setting its allowance to `0` acts as the operational kill switch — no code change or admin call is involved.

## Dependencies

- This project uses **OpenZeppelin Contracts version 5.4.0**.
- Make sure to install the correct version for compatibility:

```bash
npm install @openzeppelin/contracts@5.4.0
```

## Compiler Settings

For reproducible builds / source verification:

| Setting | Value |
| --- | --- |
| Solidity | 0.8.28 |
| Optimizer | enabled, 200 runs |
| viaIR | true |
| EVM version | cancun |

## Deployments (Ethereum Mainnet)

| Contract | Address | Status |
| --- | --- | --- |
| CBKToken | [`0x61Fc6FFff56d7BCFD0a1EB865eBDc4ddd1CF2bBC`](https://etherscan.io/address/0x61Fc6FFff56d7BCFD0a1EB865eBDc4ddd1CF2bBC#code) | source verified (Etherscan · Blockscout · Sourcify) |
| TokenSwap | [`0x81c9F41e46ab129c56F080F6FB3D36D73EEAfB88`](https://etherscan.io/address/0x81c9F41e46ab129c56F080F6FB3D36D73EEAfB88#code) | source verified (Etherscan · Blockscout · Sourcify) · swap not yet enabled (`allowance` = 0) |

Old CBK token (migration source): [`0xD85a6Ae55a7f33B0ee113C234d2EE308EdeAF7fD`](https://etherscan.io/address/0xD85a6Ae55a7f33B0ee113C234d2EE308EdeAF7fD)

These are the only addresses to use. Ignore any other address claiming to be CBK.

## License

MIT
