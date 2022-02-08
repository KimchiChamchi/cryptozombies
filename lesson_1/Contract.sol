pragma solidity ^0.4.25; // 솔리디티 버전

// Go, C++ 의 main 과 비슷한것...
contract ZombieFactory {

    // 앱 사용자(프런트)와 컨트랙트가 소통하기 위한 것.
    // 이벤트가 실행되면 프런트엔드에 어떤일이 발생했는지 전달해줌
    event NewZombie(uint zombieId, string name, uint dna);

/* 변수 선언 - 상태변수는 컨트랜트 저장소에 영구적으로 저장.
              이더리움 블록체인게 기록된다
    uint: Unsigned Integers (uint256)
          uint8, uint16, uint32 등 더 적은 비트로 선언 가능*/
    // 16진수를 위한것
    uint dnaDigits = 16;
    // 10**16 == 10^16 == 10의 16승
    uint dnaModulus = 10 ** dnaDigits;

    // 구조체 만들기
    struct Zombie {
        string name;
        uint dna;
    }
/* 배열 - 정적배열: uint[2] fixedArray; string[5] stringArray;
                   2개까지만 담을 수 있음; 5개까지만 담을 수 있음
          동적배열: uint[] array;
                   배열의 크기가 제한이 없이 계속 담을 수 있음
   public 배열: getter메소드를 생성해줌. 
               public 이면 다른 컨트랙트에서 읽을 수 있음. 쓸 수는 없음*/
    // Zombie라는 구조체가 담길 동적 배열을 만들고 그 배열의 이름을 zombies로 정함
    Zombie[] public zombies;
/* 함수 */
    // 인자명은 _ 를 붙여서 전역변수와 구별하는것이 관례
    // 함수에 private을 붙이면 다른 컨트랙트에서 접근할 수 없음
    // private함수명도 인자명처럼 다른곳에서 쓸 수 없으므로 _를 붙이는게 관례
    function _createZombie(string _name, uint _dna) private {
        // zombies배열에 Zombie구조체를 하나 추가하고 그 배열순번을 id로 저장
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // NewZombie 이벤트를 실행하여 앱 사용자(프런트)에게 알려준다
        NewZombie(id, _name, _dna);
    }
    // 함수 제어자
    // view: 함수가 데이터를 보기만 하고 변경할 수는 없음
    // pure: 함수가 앱 데이터에 접근하지 않는 것..오직 매개변수에만 의존한다
    //  솔리티디 컴파일러가 view, pure 중 무엇을 사용하는게 좋을지 알려준다
    function _generateRandomDna(string _str) private view returns (uint) {
        // _str을 keccak256()를 통해 랜덤 256비트 16진수로 바꿔서 저장
        uint rand = uint(keccak256(_str));
        // 이를 10의 16승으로 나눈 나머지를 반환
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        // 랜덤DNA는 좀비이름을 랜덤으로 256비트 16진수로 만들어낸 값을
        // 10^16으로 나눈 나머지값으로 만듦.
        uint randDna = _generateRandomDna(_name);
        // 해당 이름과 DNA를 가진 좀비를 새 구조체를 만들어 zombies배열에 추가
        _createZombie(_name, randDna);
    }

}