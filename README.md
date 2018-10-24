# rungeth

## 安装
### for mac 

```
brew update
brew upgrade
brew tap ethereum/ethereum
brew install ethereum
```

### for ubuntu 

```
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

## 开发者模式启动
```
geth --datadir ./devdata --networkid 18 --port 30303 --rpc --rpcaddr 0.0.0.0 --rpcvhosts "*"  --rpcport 8545 --rpcapi 'db,net,eth,web3,personal' --rpccorsdomain '*'  --dev --dev.period 1 console 2> 1.log
```
