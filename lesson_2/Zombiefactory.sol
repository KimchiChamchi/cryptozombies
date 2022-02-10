pragma solidity ^0.4.17;

contract ZombieFactory {
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    /*  매핑은 스토리지에만 사용될 수 있다. 
    '키'를 가지고 '값'을 찾는데 쓰인다
    */
    //        키          값             사용할 이름
    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    function _createZombie(string _name, uint256 _dna) internal {
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;
        /* msg.sender 는 솔리디티의 내장 전역변수라 할 수 있다
            현재 함수를 호출한 사람이나 스마트 컨트랙트의 주소를 가리키는 변수*/
        // zombieToOwner에 id를 키로 address를 찾고 값에 사용자의 주소를 저장
        zombieToOwner[id] = msg.sender;
        // ownerZombieCount매핑에 사용자주소를 키로 찾은 uint에 +1 해준다
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    // 랜덤DNA 생성 함수
    function _generateRandomDna(string _str) private view returns (uint256) {
        // 랜덤값은 전달인자를 keccak256로 생성된 256비트 16진수 값
        uint256 rand = uint256(keccak256((_str)));
        // 그 랜덤값을 10의 16승으로 나눈 나머지를 반환
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        /*require: ()안의 내용이 참이면 계속해서 진행, 거짓이면 에러메시지 발생 */
        // 사용자의 ownerZombieCount 값이 0이면
        // 아직 새로 만든 좀비가 없는 상태이므로 계속 진행
        require(ownerZombieCount[msg.sender] == 0);
        // 랜덤 DNA는 _generateRandomDna함수에 전달인자(_name)를 매개변수로 만든다
        uint256 randDna = _generateRandomDna(_name);
        // 랜덤DNA의 마지막 두자리를 빼기 위한 과정
        // 예) 123456 - (123456/100의 나머지)
        //     -> 1234몫 나머지 56이므로 123456-56=123400이 된다
        randDna = randDna - (randDna % 100);
        // 랜덤DNA와 이름을 가지고 새로운 좀비 생성
        _createZombie(_name, randDna);
    }
}
