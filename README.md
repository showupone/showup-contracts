localhost

```
anvil --fork-url https://mainnet.infura.io/v3/bf3ffbdfe9984886831c5f44711ec9df
```

Test deploy

```
forge script script/ShowUpPass.s.sol --broadcast --rpc-url http://127.0.0.1:8545

```

Deploy

```
forge script script/ShowUpPass.s.sol --broadcast --verify --rpc-url ${GOERLI_RPC_URL}
```
