# cbk-token-contract

Official CBK (Cobak Token) ERC20 contract source.

## Token

| Item | Value |
| --- | --- |
| Name | Cobak Token |
| Symbol | CBK |
| Decimals | 18 |
| Total Supply | 100,000,000 CBK |
| Standard | OpenZeppelin ERC20 (immutable, no admin functions) |

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

## Deployments

| Network | Address | Status |
| --- | --- | --- |
| Ethereum Mainnet | (to be deployed) | — |
| Sepolia (testnet) | [`0x46c96Ec922E3A7148ba4Df754C9D6db57F86bF65`](https://sepolia.etherscan.io/address/0x46c96Ec922E3A7148ba4Df754C9D6db57F86bF65#code) | source verified (Etherscan · Blockscout · Sourcify) |

## License

MIT
