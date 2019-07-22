### 在局域网内搭建多节点私有以太坊网络


局域网内组建多节点以太坊网络实验，实验环境需要至少2台主机，如果没有，也可以尝试在本机开启2个geth进程，需要注意的是同一主机上做实验时，需要关闭ipc服务，否则可能存在问题。

实验步骤如下：

#### 1. 在主机一上初始化并启动geth 

注意事项：最好找一个空目录，拷贝genesis.json拷贝到该目录进行实验！



- 1.1 初始化


```
geth init genesis.json --datadir ./data
```

- 1.2 启动


```
geth --datadir ./data --networkid 18 --port 30303 --rpc  --rpcport 8545 --rpcapi 'db,net,eth,web3,personal' --rpccorsdomain '*' --gasprice 0  console 2> 1.log
```

- 1.3 查看节点信息


```
> admin.nodeInfo
{
  enode: "enode://63692c0e2ed5a7f8c176e5381ff98c25710190d871e526925eab7230068225b70018f8ad702845963e16649f0028edf816764325911acd051e1de41edb2529ad@[::]:30303",
  id: "29b9cf5002270863aabaef41cf28b51a6a42d4622b59ae3abeefb390ce2c65cf",
  ip: "::",
  listenAddr: "[::]:30303",
  name: "Geth/v1.8.17-stable-8bbe7207/linux-amd64/go1.10",
  ports: {
    discovery: 30303,
    listener: 30303
  },
  protocols: {
    eth: {
      config: {
        chainId: 18,
        eip150Hash: "0x0000000000000000000000000000000000000000000000000000000000000000",
        eip155Block: 0,
        eip158Block: 0,
        homesteadBlock: 0
      },
      difficulty: 2,
      genesis: "0xc1d47d80957422239f97de9b123499f1e6230ddbf3bc2f2c5af1b033c9d9ea3e",
      head: "0xc1d47d80957422239f97de9b123499f1e6230ddbf3bc2f2c5af1b033c9d9ea3e",
      network: 18
    }
  }
}

```

- 1.4 查看peer节点数量


```
> net.peerCount
0

```

- 1.5 创建一个账户


```
> personal.newAccount("123")
"0x5f306bccad215ed3ec9d6bec27986de23a1f5938"


```

#### 2. 在第二台主机上进行操作 

- 2.1 使用相同创世块文件初始化


```
geth init genesis.json --datadir data
```


- 2.2 启动geth，注意参数要增加bootnodes

在这里指定要加入的网络是 10.211.55.3:30303 对应的网络，这其实也就是主机一上节点的网络，也可以在启动时不添加--bootnodes，而在启动后使用 admin.addPeer("enode://63692c0e2ed5a7f8c176e5381ff98c25710190d871e526925eab7230068225b70018f8ad702845963e16649f0028edf816764325911acd051e1de41edb2529ad@10.211.55.3:30303") 添加节点的方式

```
geth --datadir ./data --networkid 18 --port 30303 --rpc  --rpcport 8545 --rpcapi 'db,net,eth,web3,personal' --rpccorsdomain '*'  --bootnodes "enode://63692c0e2ed5a7f8c176e5381ff98c25710190d871e526925eab7230068225b70018f8ad702845963e16649f0028edf816764325911acd051e1de41edb2529ad@10.211.55.3:30303" console 2>1.log
```


- 2.3  查看网络节点情况


```
> admin.peers
[{
    caps: ["eth/63"],
    enode: "enode://63692c0e2ed5a7f8c176e5381ff98c25710190d871e526925eab7230068225b70018f8ad702845963e16649f0028edf816764325911acd051e1de41edb2529ad@10.211.55.3:30303",
    id: "29b9cf5002270863aabaef41cf28b51a6a42d4622b59ae3abeefb390ce2c65cf",
    name: "Geth/v1.8.17-stable-8bbe7207/linux-amd64/go1.10",
    network: {
      inbound: false,
      localAddress: "10.211.55.2:51517",
      remoteAddress: "10.211.55.3:30303",
      static: false,
      trusted: false
    },
    protocols: {
      eth: {
        difficulty: 2,
        head: "0xc1d47d80957422239f97de9b123499f1e6230ddbf3bc2f2c5af1b033c9d9ea3e",
        version: 63
      }
    }
}]
```

从当前结果来看，已经可以看到网络加入成功，在network内容中，可以看到两个节点ip

- 2.4 节点2创建账户


```
> personal.newAccount("123")
"0x4f8d8b1a1a941eaf947a3a657c176a40763b2cfb"
```

- 2.5 启动挖矿、查看余额


```
> miner.start(1)
null
> eth.getBalance(eth.accounts[0])

25000000000000000000
```

- 2.6 转账给主机上节点的账户 


```
> personal.unlockAccount(eth.accounts[0], "123")
true


```

需要先解锁，然后转账4个以太，web3.toWei是转换函数，它的执行结果是将传入的值单位转换为以太，也就是说如果传入参数为4，最终结果其实是4000000000000000000.

```
> eth.sendTransaction({from:eth.accounts[0],to:"0x5f306bccad215ed3ec9d6bec27986de23a1f5938", value:web3.toWei(4)})
"0xf6bce81cfc309f1c56643217ab4f2bc7eb28f8879d99e67bbe0fa43373136d3a"
```

- 2.7 在主机二的节点上查询节点1账户的余额

```
> acc2="0x5f306bccad215ed3ec9d6bec27986de23a1f5938"
"0x5f306bccad215ed3ec9d6bec27986de23a1f5938"
> eth.getBalance(acc2)
4000000000000000000
```


#### 3. 在主机一节点上查询账户余额


```
> eth.getBalance(eth.accounts[0])
4000000000000000000
```

通过实验，我们使用多个节点共同组成一个私有网络，关键点是创世块文件要相同，大家使用相同的网络id。



测试数据：

```
> admin.nodeInfo
{
  enode: "enode://b93e6e616e73f3e2ac36453fb712ec0c9573459c4554ccaa19be8946e20353ba4af2ec8e63766dfba83c74ed48107433ccbefed261daa6e6003d4fdeb31dcce0@127.0.0.1:30303",
  enr: "0xf896b8407047aba1bdc2bb89ccdb591645a608e8d205620b2fce9e0b2bb5eb54ac173089495a1fc71fadb6f2468b52f9d82f05464284eac398f9c7ee7f8118b0808a50e90183636170c6c5836574683f826964827634826970847f00000189736563703235366b31a102b93e6e616e73f3e2ac36453fb712ec0c9573459c4554ccaa19be8946e20353ba8374637082765f8375647082765f",
  id: "3430c6c8b3a5d4d5951b662d9295b535910c72ec52741ffe89b9cdd6766245e8",
  ip: "127.0.0.1",
  listenAddr: "[::]:30303",
  name: "Geth/v1.8.22-stable/darwin-amd64/go1.11.5",
  ports: {
    discovery: 30303,
    listener: 30303
  },
  protocols: {
    eth: {
      config: {
        chainId: 18,
        eip150Hash: "0x0000000000000000000000000000000000000000000000000000000000000000",
        eip155Block: 0,
        eip158Block: 0,
        homesteadBlock: 0
      },
      difficulty: 2,
      genesis: "0xc1d47d80957422239f97de9b123499f1e6230ddbf3bc2f2c5af1b033c9d9ea3e",
      head: "0xc1d47d80957422239f97de9b123499f1e6230ddbf3bc2f2c5af1b033c9d9ea3e",
      network: 18
    }
  }
}
```

```
192.168.1.24
```
