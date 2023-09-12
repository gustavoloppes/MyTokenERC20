// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {

    // getters
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    // functions
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256);
}




    contract MyToken is IERC20 {
    string public constant name = "MY TOKEN";
    string public constant symbol = "MTK";
    uint8 public constant decimals = 18;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowed;
    uint256 _totalSupply = 10 ether;


    constructor() {
        _balances[msg.sender] = _totalSupply;
    }



    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return _balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= _balances[msg.sender]);
        _balances[msg.sender] = _balances[msg.sender]-numTokens;
        _balances[receiver] = _balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }


    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        _allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return _allowed[owner][delegate];
    }


    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= _balances[owner]);
        require(numTokens <= _allowed[owner][msg.sender]);
       
        _balances[owner] = _balances[owner]-numTokens;
        _allowed[owner][msg.sender] = _allowed[owner][msg.sender]-numTokens;
        _balances[buyer] = _balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens); 
        return true;
    }
}