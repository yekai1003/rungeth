### hello.sol 

```
//pragma 关键字
//solidity 关键字
//^0.5.0 代表告诉编译器器的版本，具体还要和IDE环境编译器器相适应
pragma solidity ^0.5.0;
//contract 类似于class，定义合约名字
contract hello {
    //定义⼀一个字符串串类型的数字，msg为状态变量量，为存储其数据，需要⽀支付gas费⽤用
    string public msg;
    //构造函数
    constructor(string memory _msg) public {
        msg = _msg;

    }
    //修改msg
    function setMsg(string memory _msg) public {
        msg = _msg;

    }

}

```

```
pragma solidity^0.5.0;
pragma experimental ABIEncoderV2;
//ABIEncoderV2 可以⽀支持结构体等特殊类型作为返回值
// storage & memory具体的区别
// 在全局区的变量量使⽤用storage存储
// 在函数声明时，使⽤用值传递，此时如果有特殊要求，如string类型需加memory强调
// 在函数体内部，storage可以理理解为指针，指向某内存区域，memory变量量为值传递
contract Person {
    struct Person {
        uint age;
        string name;

    }
    //Person数组,动态
    Person[] persons;
    function addPerson(uint _age, string memory _name) public {
        // p是单独申请了了⼀一个Person区域
        Person memory p = Person(_age, _name);
        // 通过值传递的⽅方式将p传递，在persons动态数组内再开辟⼀一块区域
        persons.push(p);

    }
    function getPerson(uint _index) public view returns (Person
                                                         memory) {
        return persons[_index];

    }
    //修改数组某个元素
    function setPerson(uint _index, uint _age) public {
        Person storage p = persons[_index];
        p.age = _age;

    }
    //不不会修改数组元素
    function setPerson2(uint _index, uint _age) public {
        Person memory p = persons[_index];
        p.age = _age;

    }

}

```

```

pragma solidity^0.5.5;
contract Money {
    //owner
    address payable public owner;
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
        uint random =
            uint(keccak256(abi.encode(now,msg.sender,"tuhao"))) % 100;
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
