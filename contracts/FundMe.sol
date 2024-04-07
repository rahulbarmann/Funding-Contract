//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "./PriceConvertor.sol";

// error FundMe_NotOwner();  defining an error

/**
 * @title A contract for crowd funding
 * @author Rahul Barman
 * @notice This contract is to demo a funding contract
 * @dev This implements price feeds as our library
 */

contract FundMe {
    using PriceConvertor for uint256; // This means that all the functions in the PriceConverter library are available to call on any uint256. But they have to be "internal functions" *(very important)

    address[] public donatersList;
    mapping(address => uint256) public history;

    uint256 constant MIN_USD = (50 * 1e18); // constant --> those var which can be updated only once but has to initialized on declaration.
    address public immutable i_owner; // immutable --> those var which can be updated only once but can be initialized only inside constructor.

    // both constant and immutable saves gas

    address public priceFeedAddress;

    constructor(address _priceFeedAddress) {
        // constructor will run instantly as the contract is deployed
        i_owner = msg.sender; // msg.sender at deployement will be the addess of the person who deployed the contract
        priceFeedAddress = _priceFeedAddress;
    }

    function fund() public payable {
        // payable specifier for specifying that the we can send money through this function
        // require (if false, then execute this and revert)
        require(
            msg.value.priceConvertor(priceFeedAddress) >= MIN_USD,
            "Bhai tu thora bkl hai kya?"
        ); // msg.value --> returns how much "value" someone is sending through this function
        // the msg.value is considered as the first parameter that is passed in the priceConvertor function library
        donatersList.push(msg.sender);
        history[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < donatersList.length; i++) {
            history[donatersList[i]] = 0;
        }

        donatersList = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "laure lag gaye bhai");
    }

    modifier onlyOwner() {
        // anytime the onlyOwner specifier will be used in a function, it will jump to here and first complete all task here then move back to its function
        require(i_owner == msg.sender, "Tu owner hai kya laure?");

        // if (msg.sender != i_owner) revert FundMe_NotOwner();    another way to do the above and FundMe_NotOwner is an error defined at the top

        _; // move back to the fucntion and do the rest remaining in there
    }

    receive() external payable {
        // if you pay the contract without any msg.data (calldata) then receive() will run
        fund();
    }

    fallback() external payable {
        // if you pay the contract with some calldata but it does not point to any defined function in the contract, then fallback() will run
        fund();
    }

    // $4025.19569965
}

// 0x694AA1769357215DE4FAC081bf1f309aDC325306  --> contract address of ETH/USD

// Contract can also hold funds in their contract address just like a wallet address

/* What is Reverting?
    Undo any actions before, and send the remaining gas back */

// Interface github --> https://github.com/smartcontractkit/chainlink/blob/master/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol

/*
    Ether is send to contract->
       
       Is msg.data empty?
            /    \   
          yes     no
          /        \
    receive() ?   fallback()   
      /   \
    yes   no
    /       \
receive()   fallback()

*/
