// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from './PriceConverter.sol';

contract FundMe {
    using PriceConverter for uint256;

    address public immutable i_owner;
    //We must multiply by 10^18 because we manipulate 18decimals
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;

    mapping (address funders => uint256 amounFunded) public fundedAmountBy;

    constructor() {
        i_owner = msg.sender;    
    }

    function fund() public payable {
        require(msg.value.getConversionRate() > MINIMUM_USD, "The minimum ammount to send is 5 USD");
        fundedAmountBy[msg.sender] = fundedAmountBy[msg.sender] + msg.value;
        funders.push(msg.sender);
    }


    modifier minimumAmount {
        require(msg.value > 1e18, "The minimum ammount to send is 1 ETH");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, 'You are not the owner !');
        _;
    }

    function withdrawal() public onlyOwner {
        //Empty the mapping 'fundedAmountBy' 
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            fundedAmountBy[funder] = 0;
        }
        funders = new address[](0);

        //As it returns nothing, we can write 
        (bool successCall, ) = payable(msg.sender).call{value: address(this).balance}("");    
        require(successCall, "Call to send ETH failed");

    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}
