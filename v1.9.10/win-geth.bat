geth --datadir ./data --networkid 1008  --http --http.addr 0.0.0.0 --http.vhosts "*" --http.api "db,net,eth,web3,personal" --http.corsdomain "*" --allow-insecure-unlock  console 2> 1.log
