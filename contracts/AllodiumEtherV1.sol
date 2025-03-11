// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Allodium {
  string public name = "Allodium";
  string public symbol = "ALOD";
  string public standart = "@Allodium v.0.1";
  uint256 public totalSupply;  // Исправлено с string на uint256
  address public ownerOfContract; // Исправлено с string на address
  uint256 private _userId; // Исправлено с string на uint256

  address[] public holderToken;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  mapping(address => TokenHolderInfo) public tokenHolderInfos;

  struct TokenHolderInfo {
    uint256 _tokenId;
    address _from;
    address _to;
    uint256 _totalToken;  // Исправлено с _total на _totalToken
    bool _tokenHolder;
  }

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  constructor(uint256 _initialSupply) {
    ownerOfContract = msg.sender;
    balanceOf[msg.sender] = _initialSupply;
    totalSupply = _initialSupply;
  }

  function inc() internal {
    _userId++; // Теперь _userId типа uint256, можно инкрементировать
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balanceOf[msg.sender] >= _value, "Insufficient balance");
    inc();

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    TokenHolderInfo storage tokenHolderInfo = tokenHolderInfos[_to];

    tokenHolderInfo._to = _to;
    tokenHolderInfo._from = msg.sender;
    tokenHolderInfo._tokenHolder = true;
    tokenHolderInfo._totalToken = _value;  // Исправлено с _total на _totalToken
    tokenHolderInfo._tokenId = _userId;

    holderToken.push(_to);

    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[_from], "Insufficient balance");
    require(_value <= allowance[_from][msg.sender], "Allowance exceeded");

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;

    allowance[_from][msg.sender] -= _value;

    emit Transfer(_from, _to, _value);

    return true;
  }

  function getTokenHolderData(address _address) public view returns (
    uint256, address, address, uint256, bool
  ) {
    return (
      tokenHolderInfos[_address]._tokenId,
      tokenHolderInfos[_address]._to,
      tokenHolderInfos[_address]._from,
      tokenHolderInfos[_address]._totalToken,
      tokenHolderInfos[_address]._tokenHolder
    );
  }

  function getTokenHolder() public view returns (address[] memory) {
    return holderToken;
  }
}
