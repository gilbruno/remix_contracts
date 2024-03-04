// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from './PriceConverter.sol';

contract FundMe {
    using PriceConverter for uint256;

    //We must multiply by 10^18 because we manipulate 18decimals
    uint256 minimumUsd = 5e18;
    address[] funders;

    mapping (address funders => uint256 amounFunded) public fundedAmountBy;

    function fund() public payable {
        require(getConversionRate(msg.value) > minimumUsd, "The minimum ammount to send is 5 USD");
        fundedAmountBy[msg.sender] = fundedAmountBy[msg.sender] + msg.value;
    }


    modifier minimumAmount {
        require(msg.value > 1e18, "The minimum ammount to send is 1 ETH");
        _;
    }


    function getVersion() public view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    function withdrawal() public {
        //Empty the mapping 'fundedAmountBy' 
        for (uint256 i = 0; i < fundedAmountBy.length; i++) {
            address funder = funders[i];
            fundedAmountBy[i] = 0;
        }
        funders = new address[](0);

        //Transfer : Revert in case of failure
        //payable(msg.sender).transfer(address(this).balance);

        //Send : Do not Revert in case of failure (so we must implement revert ourself)
        //bool successSend = payable(msg.sender).send(address(this).balance);
        //require(successSend, "Send Fails !");

        //Call : can call like every function by passing informations on the function
        // But we do not call any function so leave empty string
        //(bool successCall, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");    
        //As it returns nothing, we can write 
        (bool successCall, ) = payable(msg.sender).call{value: address(this).balance}("");    
        require(successCall, "Call to send ETH failed");

    }

}
