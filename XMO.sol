/**
 *Submitted for verification at BscScan.com on 2021-11-05
*/

pragma solidity ^0.5.17;

contract XMOToken {
  string private _name;
  string private _symbol;
  uint32 private _decimals;
  constructor(string memory name, string memory symbol, uint32 decimals) public {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }
  function name() public view returns(string memory) {
    return _name;
  }
  function symbol() public view returns(string memory) {
    return _symbol;
  }
  function decimals() public view returns(uint32) {
    return _decimals;
  }
}

contract XMO is XMOToken {
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    
    string constant _tokenName = "Moonsteria";
    string constant _tokenSymbol = "XMO";
    uint32 constant _tokenDecimals = 18;
    uint256 public _totalSupply = 500000000000000000000000;
    
    constructor() public payable XMOToken(_tokenName, _tokenSymbol, _tokenDecimals) {
        mint(msg.sender, _totalSupply);
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function mint(address _to, uint256 _value) internal {
        require(_value != 0);
        balances[_to] = balances[_to] + _value;
        emit Transfer(address(0), _to, _value);
    }
    function burn(uint256 _value) public returns (bool) {
        require(_value != 0);
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - _value;
        _totalSupply = _totalSupply - _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from] - _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        _totalSupply = _totalSupply - _value;
        emit Burn(_from, _value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed burner, uint256 value);
}
