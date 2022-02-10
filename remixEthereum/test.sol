pragma solidity >=0.4.0;

// 클래스와 비슷
contract SimpleCoin{
    // 멤버 필드
    //자료구조   키        값               변수명
    mapping (address => uint256) public coinBalance;

    // 생성자
    constructor() public{

        coinBalance[msg.sender] = 10000;
    }
    // 메서드
    function transfer(address _to, uint256 _amount) public{
        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] +=_amount;
    }
}