## 1. hello.sol 
```
pragma solidity^0.5.0;
//版本编译器要在0.5.0以上

//合约名称
contract hello {
    //状态变量，改变需要消耗以太
    string public storeData;//public变量会自动提供查询方法
    //设置变量
    function setData(string memory _inData) public {
        storeData = _inData;
    }
    //查询变量，对于public变量可以不提供此方法
    function getData() public view returns (string memory) {
        return storeData;
    } 
}
```
## 2. storage.sol

```
pragma solidity^0.5.0;
pragma experimental ABIEncoderV2;
//ABIEncoderV2 可以支持结构体等特殊类型作为返回值


// storage & memory具体的区别 
// 在全局区的变量使用storage存储
// 在函数声明时，使用值传递，此时如果有特殊要求，如string类型需加memory强调
// 在函数体内部，storage可以理解为指针，指向某内存区域，memory变量为值传递

contract Person {
    
    struct Person {
        uint age;
        string name;
    }
    
    //Person数组,动态
    Person[] persons;
    
    function addPerson(uint _age, string memory _name) public {
        // p是单独申请了一个Person区域 
        Person memory p = Person(_age, _name);
        // 通过值传递的方式将p传递，在persons动态数组内再开辟一块区域
        persons.push(p);
    }
    
    function getPerson(uint _index) public view returns (Person memory) {
        return persons[_index];
    }
    //修改数组某个元素 
    function setPerson(uint _index, uint _age) public {
        Person storage p = persons[_index];
        p.age = _age;
    }
    //不会修改数组元素
    function setPerson2(uint _index, uint _age) public {
        Person memory p = persons[_index];
        p.age = _age;
    }
    
    
}
```

## 3. random.sol
```
pragma solidity^0.5.0;

// 获得随机数 
contract random {
    
    function getRandom() public view returns (bytes32) {
        //keccak256 新版0.5.0之后只支持一个参数，需要使用abi.encode进行编码
        return keccak256(abi.encode(msg.sender,"haha",now));
    }
    function getRandom2() public view returns (uint) {
        return uint(keccak256("hah")) % 100;
    }
}
```
## 4. funcKey.sol
```
pragma solidity^0.5.0;

contract funcKey {
    address public ceo;
    uint256 private total;
    constructor() public {
        total = 10000000;
        ceo = msg.sender; // fuzhi 
    }
    // 判断2个字符串是否相等
    function isEqual(string memory _x, string memory _y) private pure returns (bool) {
        if( keccak256(abi.encode(_x)) == keccak256(abi.encode(_y))) {
            return true;
        }
        return false;
    }
    
    function show() pure public returns (bool) {
        return isEqual("abc","abc");
    }
    
    modifier onlyceo() {
        require(msg.sender == ceo,"only ceo can call!");
        _;
    }
    function getBalance() public view returns (uint256) {
        require(msg.sender == ceo,"only ceo can call");
        return total;
    }
    
  
    function getBalance2() public onlyceo view returns (uint256) {
        return total;
    }
    
}
```
## 5. money.sol

0.5.0以上的版本，限制了payable的用处，账户地址必须是payable的才可以转账
```
pragma solidity^0.5.5;

contract Money {
    
    //owner 
    address  payable public owner;
    constructor() public {
        owner = msg.sender;//guan li yuan fu zhi 
    }
    
    // chongzhi 
    function payMoney() payable public {
        //noting to do 
    }
    //fallback payable - > wallet transfer to address ok 
    function() external payable {
        
    }
    
    //show balance 
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    //qu qian 
    function getMoney() public payable {
        address payable who = msg.sender;
        require(getBalance() > 1 ether);
        who.transfer(1 ether);//send 1 ether to who 
    }
    
    //destroy contract 
    function kill() public {
        require(msg.sender == owner);
        selfdestruct(owner);//destroy contract 
    }
    
    
    
}

```

## 6. redpacket.sol

```
pragma solidity^0.5.5;

contract redpacket {
    address payable public tuhao;//dingyi tuhao 
    uint public number ;// hong bao shu liang 
    constructor(uint _number) payable public {
        tuhao = msg.sender;//chuang jian heyue shi tuhao 
        number = _number;
    }
    //show balance 
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    //qiang hong bao 
    function stakeMoney() public payable returns (bool) {
        require(number > 0);
        require(getBalance() > 0); // pan duan yu e > 0 
        number --;
        uint random = uint(keccak256(abi.encode(now,msg.sender,"tuhao"))) % 100;
        uint balance = getBalance();
        msg.sender.transfer(balance * random / 100 );
        return false;
    }
    
    //destroy contract 
    function kill() public {
        require(msg.sender == tuhao);
        selfdestruct(tuhao);//destroy contract 
    }
    
}
```

## 7. bet.sol

```
pragma solidity^0.5.0;

contract Bet {
    address public owner;// guanli zhe 
    bool isFinshed;// shi fou yijing jieshu 
    struct Player {
        address payable addr;
        uint amount;
    }
    
    Player[] inBig;// xia da de ren 
    Player[] inSmall;//xia xiao de ren 
    
    uint totalBig;
    uint totalSmall;
    uint nowtime;
    //gou zao hanshu 
    constructor() public {
        owner = msg.sender;
        totalSmall = 0;
        totalBig = 0;
        isFinshed = false;
        nowtime = now;
    }
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    function getNowtime() public view returns (uint) {
        return now;
    }
    //xia zhu 
    function stake(bool flag) public payable returns (bool) {
        require(msg.value > 0);
        //gou zao wanjia 
        Player memory p = Player(msg.sender, msg.value);
        if(flag) {
            //big 
            inBig.push(p);
            totalBig += p.amount;
        }
        else {
            //small 
            inSmall.push(p);
            totalSmall += p.amount;
        }
        return true;
    }
    
    //kai jiang 
    function open() payable public returns(bool) {
        //shi jian dao cai kai jiang 
        require(now > nowtime + 20);
        //yi jing kai guo ,bu neng zai kai 
        require(!isFinshed);
        // de dao kai jiang zhi sui ji shu 18 yi nei 0-8 xiao ,9-17 big 
        uint points = uint(keccak256(abi.encode(msg.sender,now,block.number))) % 18;
        uint i = 0;
        Player memory p;
        if(points >= 9) {
            //big win : benjin + jiangjin 
            for(i = 0; i < inBig.length; i ++) {
                p = inBig[i];
                p.addr.transfer(p.amount+totalSmall*p.amount/totalBig);
            }
        }
        else {
            //small win 
            for(i = 0; i < inSmall.length; i ++) {
                p = inSmall[i];
                p.addr.transfer(p.amount+totalBig*p.amount/totalSmall);
            }
        }
        isFinshed = true;
        return true;
    }
    
  
    
}
```

## 8. auction.sol

```

pragma solidity^0.5.0;

contract auction {
    
    address payable public seller;// mai jia 
    
    // zui gao chu jiazhe yiji jin'e
    address payable public buyer;
    uint public auctionAmount;//zuigao jin e 
    
    uint auctionEndTime ;
    bool isFinshed;
    
    event BidEvent(address _buyer, uint _highAmount);
    
    constructor(address payable _seller, uint _duration) public {
        seller = _seller;
        auctionEndTime = _duration + now;
        isFinshed = false;
    }
    //jing pai 
    function bid() public payable {
        require(!isFinshed);
        require(now < auctionEndTime);// shi jian xian zhi 
        require(msg.value > auctionAmount);
        if (auctionAmount > 0 && address(0) != buyer) {
            buyer.transfer(auctionAmount);//tui hui qian gei zhi qian de ren
        }
        buyer = msg.sender;
        auctionAmount = msg.value;
        emit BidEvent(buyer,auctionAmount);
    }
    //jie shu jing pai 
    function auctionEnd() public payable {
        require(now >= auctionEndTime);//chao guo jing pai shi jian 
        require(!isFinshed);
        isFinshed = true;
        seller.transfer(auctionAmount);
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
}

```


## 9. ballot.sol 

```
pragma solidity^0.5.0;

contract ballot {
    //xuan min xin xi jie gou
    struct Voter {
        uint weight;//keyi tou piao shu 
        bool isVoted;// shi fou yi jing tou le 
        address delegate;// shou quan gei qi ta ren 
        uint index;//xuan ze yi an bian hao 
    }
    // yi an jie gou 
    struct Proposal {
        bytes32 name;//yi an ming 
        uint voteCount;// tou piao shu 
    }
    
    Proposal[] public proposals;//yian array 
    address public chairman;// zhu chi ren 
    mapping(address=>Voter) public voters;//xuan min xin xi 
    
    //gou zao hanshu 
    constructor(bytes32[] memory _proposalNames) public {
        chairman = msg.sender;
        voters[chairman].weight = 1;//zhu chi ren 1 piao 
        uint i = 0;
        for(i = 0; i < _proposalNames.length; i ++) {
            Proposal memory p = Proposal(_proposalNames[i],0);
            proposals.push(p);
        }
    }
    //shou quan 
    function giveRightToVoter(address _to) public {
        require(msg.sender == chairman,"must be chairman");
        require(!voters[_to].isVoted);
        require(voters[_to].weight == 0);
        voters[_to].weight = 1; // shou quan 
    }
    //wei tuo 
    function delegate(address _to) public {
        address voter = msg.sender;
        require(!voters[voter].isVoted,"must not voted");
        require(voters[voter].weight > 0,"must weight > 0");
        require(_to != voter);
        //a_->b - > c - >d 
        while( voters[_to].delegate != address(0) ) {
            _to = voters[_to].delegate;
            require(_to != voter);
        }
        //zai zheli de dao yi ge delegate = _to 
        voters[voter].delegate = _to;
        voters[voter].isVoted = true;
        //ru guo _to yi jing tou piao ,zhichi !!
        if(voters[_to].isVoted) {
            uint index = voters[_to].index;
            proposals[index].voteCount += voters[voter].weight;
        }
        else {
            voters[_to].weight += voters[voter].weight;
        }
        voters[voter].weight = 0;
    }
    
    //tou piao 
    function vote(uint _index) public {
        require(!voters[msg.sender].isVoted,"must not voted");
        voters[msg.sender].isVoted = true;
        voters[msg.sender].index = _index;
        // zeng jia yi an tou piao shu 
        proposals[_index].voteCount += voters[msg.sender].weight;
    }
    
    // huo qu zui gao piao de index 
    function getWinIndex() public view returns(uint) {
        uint i = 0;
        uint index = 0;
        uint maxCount = 0 ;
        for(i = 0 ; i < proposals.length; i ++) {
            if( proposals[i].voteCount > maxCount ) {
                maxCount = proposals[i].voteCount;
                index = i;
            }
        }
        return index;
    }
    
    // get win name 
    function getWinName() public view returns (bytes32) {
        uint index = getWinIndex();
        return proposals[index].name;
    }
    
    
}
```


## 10. web3.sol 

```
pragma solidity^0.5.0;

contract ping {
    string myMsg="pong2";
    function setMsg(string _msg) public {
        myMsg = _msg;
    }
    function getMsg() public view returns (string) {
        return myMsg;
    }
}
```
