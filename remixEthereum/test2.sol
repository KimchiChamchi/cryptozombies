pragma solidity ^0.4.0;

contract MappingExample {
    mapping(address => uint256) public balances;

    function update(uint256 newBalance) public {
        balances[msg.sender] = newBalance;
    }
}

contract MappingUser {
    function f() public returns (uint256) {
        MappingExample m = new MappingExample();
        m.update(100);
        return m.balances(this);
    }
}
pragma solidity ^0.4.19;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    // 여기서 시작
    struct Ps {
        uint256 age;
        string name;
    }

    // 이름과 DNA를 매개변수로 받는 좀비생성 함수를 만든다
    function createZombie(string _name, uint256 _dna) {
        //
        zombies.push(Zombie(_name, _dna));
    }
}
