// SPDX-License-Identifier: MIT

pragma solidity >=0.4.25;
// 다른파일을 불러오는 import
import "./zombiefactory.sol";

contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

/* 상속: 컨트랙트에게 컨트랙트를 상속받게 할 수 있다.
상속받는 컨트랙트는 상속해주는 컨트랙트의 함수를 사용할 수 있다 */
// ZombieFeeding는 (zombiefactory.sol파일의)ZombieFactory로부터 상속받는다
contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string _species
    ) public {
        // require ()안의 내용이 참이면 계속해서 진행, 거짓이면 에러메시지 발생
        // 사용자와
        require(msg.sender == zombieToOwner[_zombieId]);
        /* storage: 블록체인에 영구적으로 저장되는 변수
           memory: 임시적으로 저장되는 변수
              컴퓨터의 하드디스크와 램과 같다 */
        // zombies[인덱스]를 좀비 구조체인 myZombie변수에 저장
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
