# 部署Geth私有网络

本指南介绍了如何使用 Kurtosis（一种便于运行容器化软件包的工具）设置多个 Geth 节点及其对应的共识客户端的私有网络。如果节点未连接到主网或任何测试网，则称以太坊网络为私有网络。在此背景下，私有仅意味着保留或隔离，而非受保护或安全。完全可控的私有以太坊网络对于处理与网络/区块链同步等问题的核心开发人员来说很有用，作为后端。私有网络对于测试多区块和多用户场景的 Dapp 开发人员也很有用。



## 前置准备

要按照本页的教程操作，您需要安装好可正常运行的 Kurtosis（安装说明在此）以及 Docker。了解 Geth 的基础知识（参见入门指南）也会很有帮助。



## 私有网络

私有网络由多个只能相互连接的以太坊节点组成。搭建全新的权益证明网络有许多细节需要注意。仅举几例：必须为执行客户端和共识客户端生成创世区块。创世区块还将包含验证者用于在网络中质押的存款合约。然后，必须根据创世文件协调设置执行层（EL）和共识层（CL）。Kurtosis 以太坊软件包将在幕后处理所有这些操作，并允许在需要时进行自定义。

## 选择网络标识

以太坊主网的网络标识符为 1。此外，Geth 还可以通过提供不同的链标识符来连接到许多其他网络，其中一些是测试网，另一些则是基于 Geth 源代码的分叉构建的替代网络。提供一个尚未被现有网络或测试网所使用的网络标识符意味着使用该标识符的节点只能相互连接，从而形成一个私有网络。当前网络标识符的列表可在 Chainlist.org 上获取。



## 基础配置

Kurtosis是基于 Starlark 配置而设定的。请将以下内容写入名为“network_params.yaml”的文件中：

```yaml
participants:
  - el_type: geth
    cl_type: lighthouse
    count: 2
  - el_type: geth
    cl_type: teku
network_params:
  network_id: "2987"
  prefunded_accounts: '{"wallet address": {"balance": "10ETH"}}'
additional_services:
  - dora
```

这描述了所期望的网络结构。该网络将由 3 对客户端组成（执行和共识）。其中 2 对运行的是 geth/lighthouse，1 对运行的是 geth/teku。每对都将拥有数量相等的验证者。它们都将共享一个创世区块，并相互连接。对于私有网络，最好指定一个不冲突的网络标识。如果没有指定标识，Kurtosis将选择一个默认值（在撰写本文时，默认值为 3151908）。prefunded_accounts是预分配账户及金额，可以填写一个自己metamask的地址。

## 启动网络

一旦配置完成，启动网络就变得简单明了了。请执行以下命令：

```sh
kurtosis run github.com/ethpandaops/ethereum-package --args-file ./network_params.yaml --image-download always
```

这表明“ethereum-package”是一个依赖项，它定义了上述字段的含义。——“image-download”始终确保使用最新的镜像。运行它后，如果操作成功，将会产生如下所示的输出：

```sh
INFO[2024-06-03T18:05:23+02:00] ===================================================
INFO[2024-06-03T18:05:23+02:00] ||          Created enclave: dusty-soil          ||
INFO[2024-06-03T18:05:23+02:00] ===================================================
Name:            dusty-soil
UUID:            1a33b911bfa4
Status:          RUNNING
Creation Time:   Mon, 03 Jun 2024 18:04:43 CEST
Flags:

========================================= Files Artifacts =========================================
UUID           Name
48ecd031ac60   1-lighthouse-geth-0-63-0
4d9057965009   2-lighthouse-geth-64-127-0
287a1079d7a7   3-teku-geth-128-191-0
760206ace8ae   dora-config
61bcf0e4a182   el_cl_genesis_data
72fa0877e1f0   final-genesis-timestamp
c30d6e459e5d   genesis-el-cl-env-file
3e1aa28cadf3   genesis_validators_root
41e32b09194d   jwt_file
3a555e3e1238   keymanager_file
1ffd63ba783c   prysm-password
a9eabb55db42   validator-ranges

========================================== User Services ==========================================
UUID           Name                                             Ports                                         Status
35dbe5e28986   cl-1-lighthouse-geth                             http: 4000/tcp -> http://127.0.0.1:54607      RUNNING
                                                                metrics: 5054/tcp -> http://127.0.0.1:54605
                                                                tcp-discovery: 9000/tcp -> 127.0.0.1:54606
                                                                udp-discovery: 9000/udp -> 127.0.0.1:56102
2758e9a955e3   cl-2-lighthouse-geth                             http: 4000/tcp -> http://127.0.0.1:54610      RUNNING
                                                                metrics: 5054/tcp -> http://127.0.0.1:54608
                                                                tcp-discovery: 9000/tcp -> 127.0.0.1:54609
                                                                udp-discovery: 9000/udp -> 127.0.0.1:55675
5e648790d930   cl-3-teku-geth                                   http: 4000/tcp -> http://127.0.0.1:54613      RUNNING
                                                                metrics: 8008/tcp -> 127.0.0.1:54611
                                                                tcp-discovery: 9000/tcp -> 127.0.0.1:54612
                                                                udp-discovery: 9000/udp -> 127.0.0.1:62286
1f961bcf0ef7   dora                                             http: 8080/tcp -> http://127.0.0.1:54628      RUNNING
f8a7764be245   el-1-geth-lighthouse                             engine-rpc: 8551/tcp -> 127.0.0.1:54586       RUNNING
                                                                metrics: 9001/tcp -> 127.0.0.1:54587
                                                                rpc: 8545/tcp -> http://127.0.0.1:54589
                                                                tcp-discovery: 30303/tcp -> 127.0.0.1:54588
                                                                udp-discovery: 30303/udp -> 127.0.0.1:51523
                                                                ws: 8546/tcp -> 127.0.0.1:54590
33a1aa3734f0   el-2-geth-lighthouse                             engine-rpc: 8551/tcp -> 127.0.0.1:54595       RUNNING
                                                                metrics: 9001/tcp -> 127.0.0.1:54596
                                                                rpc: 8545/tcp -> http://127.0.0.1:54598
                                                                tcp-discovery: 30303/tcp -> 127.0.0.1:54597
                                                                udp-discovery: 30303/udp -> 127.0.0.1:61026
                                                                ws: 8546/tcp -> 127.0.0.1:54599
22ec7e014303   el-3-geth-teku                                   engine-rpc: 8551/tcp -> 127.0.0.1:54602       RUNNING
                                                                metrics: 9001/tcp -> 127.0.0.1:54603
                                                                rpc: 8545/tcp -> http://127.0.0.1:54600
                                                                tcp-discovery: 30303/tcp -> 127.0.0.1:54604
                                                                udp-discovery: 30303/udp -> 127.0.0.1:60590
                                                                ws: 8546/tcp -> 127.0.0.1:54601
c4655f3e76da   validator-key-generation-cl-validator-keystore   <none>                                        RUNNING
349a3759d6c8   vc-1-geth-lighthouse                             metrics: 8080/tcp -> http://127.0.0.1:54621   RUNNING
deed7eacfd93   vc-2-geth-lighthouse                             metrics: 8080/tcp -> http://127.0.0.1:54623   RUNNING

```

就是这样。kurtosis已将配置文件中指定的所有网络组件置于一个隔离环境中。该隔离环境的名称（例如上述运行中的“尘土土壤”）是与服务进行交互所必需的。到目前为止，网络应该已经开始生成和验证新的区块。要深入了解每个客户端，可以查看日志。

```sh
> kurtosis service logs dusty-soil el-1-geth-lighthouse

[el-1-geth-lighthouse] INFO [06-04|07:59:05.048] Chain head was updated                   number=495 hash=2f3200..673eee root=d3d92f..d3bd27 elapsed=3.429333ms
[el-1-geth-lighthouse] INFO [06-04|07:59:13.008] Starting work on payload                 id=0x03c53477e90934c9
[el-1-geth-lighthouse] INFO [06-04|07:59:13.008] Updated payload                          id=0x03c53477e90934c9 number=496 hash=e995db..f5310d txs=0 withdrawals=0 gas=0 fees=0 root=36638a..e3c9a9 elapsed="379.542µs"
[el-1-geth-lighthouse] INFO [06-04|07:59:17.007] Stopping work on payload                 id=0x03c53477e90934c9 reason=delivery
[el-1-geth-lighthouse] INFO [06-04|07:59:17.041] Imported new potential chain segment     number=496 hash=e995db..f5310d blocks=1 txs=0 mgas=0.000 elapsed=20.254ms     mgasps=0.000 snapdiffs=98.81KiB triediffs=454.03KiB triedirty=79.69KiB
[el-1-geth-lighthouse] INFO [06-04|07:59:17.047] Chain head was updated 
```

## 区块浏览器

您可能在上述配置中注意到添加了一个名为“dora”的额外服务。dora 是一款轻量级的区块浏览器。上述的曲率日志表明，dora 已成功作为服务启动，并可在 http://127.0.0.1:54628 访问以查看区块链。

https://github.com/ethpandaops/dora

## 与geth交互

与任何 geth 节点进行交互最直接的方式是通过 JSON-RPC。这些节点在启动时就已经配备了 RPC 服务器，并且 kurtosis 已经将这些端口暴露给了主机，这在日志中有所说明。例如，第一个 geth 节点可以通过 http://127.0.0.1:54589 访问。因此，可以通过以下方式获取当前的区块编号：

```sh
> curl -X POST -H "Content-Type: application/json" --data '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}' http://127.0.0.1:54589

{"jsonrpc":"2.0","id":1,"result":"0x332"}
```

最终，这些高斯分布服务是以 Docker 镜像的形式存在的。还可以获得对这些镜像的 shell 访问权限并进行操作，例如启动控制台。Kurtosis 通过一条命令来实现对 shell 访问的便利性：

```sh
> kurtosis service shell dusty-soil el-1-geth-lighthouse
No bash found on container; dropping down to sh shell...
/ # geth --datadir /data/geth/execution-data/ attach
Welcome to the Geth JavaScript console!

instance: Geth/v1.14.4-unstable-a6751d6f/linux-arm64/go1.22.3
at block: 830 (Tue Jun 04 2024 09:07:29 GMT+0000 (UTC))
 datadir: /data/geth/execution-data
  modules: admin:1.0 debug:1.0 engine:1.0 eth:1.0 miner:1.0 net:1.0 rpc:1.0 txpool:1.0 web3:1.0

  To exit, press ctrl-d or type exit
  >
  
  kurtosis service shell dull-rainforest el-1-geth-lighthouse
```

## 一些命令参考

可能会涉及的一些命令。



```bash
# macOS安装
brew install kurtosis-tech/tap/kurtosis

# 停止一个网络
kurtosis enclave stop my-testnet
# 删除一个网络
kurtosis enclave rm my-testnet

# 启动一个网络
kurtosis run --enclave my-testnet github.com/ethpandaops/ethereum-package --args-file ./network_params.yaml

# 进入到某个容器
kurtosis service shell my-testnet el-1-geth-lighthouse

```



## 开发者模式启动Geth

经过测试，开发者模式启动后，remix可以连接，但仅限于本地访问。

```sh
geth --datadir ./devdata --port 30303 --http --http.addr 0.0.0.0   --http.port 8545 --http.api 'db,net,eth,web3,personal' --http.corsdomain "*" --ws --ws.origins '*'  --dev --dev.period 1 console 2> 1.log
```



