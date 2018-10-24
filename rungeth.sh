#!/bin/bash
geth --datadir ./data --networkid 18 --port 30303 --rpc  --rpcport 8545 --rpcapi 'db,net,eth,web3,personal' --rpccorsdomain '*' --gasprice 0  console 2> 1.log
