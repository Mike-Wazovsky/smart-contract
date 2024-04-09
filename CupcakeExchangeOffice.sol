// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CupcakeExchangeOffice {
    // Declare state variables of the contract
    address public owner;
    mapping(address => uint) public cupcakeBalances;
    mapping(address => uint) public etherBalances;
    uint256 public exchangeRatio;

    // When 'VendingMachine' contract is deployed:
    // 1. set the deploying address as the owner of the contract
    // 2. set the deployed smart contract's cupcake balance to 100
    constructor(uint _balance, uint256 _exchangeRatio) {
        owner = msg.sender;
        cupcakeBalances[address(this)] = _balance;
        etherBalances[address(this)];
        exchangeRatio = _exchangeRatio;
    }

    // Allow the owner to increase the smart contract's cupcake balance
    function refill(uint amount) public {
        require(msg.sender == owner, "Only the owner can refill.");
        cupcakeBalances[address(this)] += amount;
    }

    // Allow anyone to sell cupcakes
    function sell(uint amount) public payable {
        require(msg.sender != address(this), "owner can't sell it's own cupcakes");
        require(amount >= 1, "You must sell at least 1 cupcake");
        require(msg.value >= amount, "You must pay at least 1 ETH per cupcake");
        require(cupcakeBalances[address(this)] >= amount, "Not enough cupcakes in stock to complete this purchase");
        cupcakeBalances[msg.sender] -= amount;
        cupcakeBalances[address(this)] += amount;
        payable(msg.sender).transfer(amount * exchangeRatio);
    }

    // Allow anyone to purchase cupcakes
    function purchase(uint amount) public payable {
        require(msg.sender != address(this), "owner can't purchase it's own cupcakes");
        require(amount >= 1, "You must purchase at least 1 cupcake");
        require(msg.value >= amount * exchangeRatio * 1 ether, "You don'y have sufficient ETH for this amount of cupcakes");
        require(cupcakeBalances[address(this)] >= amount, "Not enough cupcakes in stock to complete this purchase");
        cupcakeBalances[address(this)] -= amount;
        cupcakeBalances[msg.sender] += amount;
        payable(address(this)).transfer(amount * exchangeRatio);
    }

    // Allow owner to change cupcakes exchange ration
    function setNewExchangeRatio(uint256 newExchangeRatio) public {
        require(newExchangeRatio > 0, "ExchangeRatio cannot be <=0");
        require(msg.sender == owner, "Only owner is permitted to change exchange ratio");
        exchangeRatio = newExchangeRatio;
    }
}
