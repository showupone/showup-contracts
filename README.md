Test deploy

```
anvil --fork-url ${MAINNET_RPC_URL}
forge script script/MinterV2.s.sol --broadcast --rpc-url localhost
```

Deploy

```
forge script script/MinterV2.s.sol --broadcast --verify --rpc-url mainnet
```
