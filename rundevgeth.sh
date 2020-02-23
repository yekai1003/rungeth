#!/bin/bash
#geth --datadir ./data --networkid 18 --port 30303 --rpc --rpcaddr 0.0.0.0 --rpcvhosts "*"  --rpcport 8545 --rpcapi 'db,net,eth,web3,personal' --rpccorsdomain '*' --ws  --gasprice 0 --dev --dev.period 1 console 2> 1.log
geth --datadir ./devdata --networkid 18 --port 30303 --rpc --rpcaddr 0.0.0.0 --rpcvhosts "*"  --rpcport 8545 --rpcapi 'db,net,eth,web3,personal' --rpccorsdomain '*' --ws --wsorigins '*'  --gasprice 0 --allow-insecure-unlock --dev --dev.period 1 console 2> 1.log
