// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

//Import for Remix 
import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract FundMe {

    modifier minimumAmount {
        require(msg.value > 1e18, "The minimum ammount to send is 1 ETH");
        _;
    }

    function fund() public payable minimumAmount {
        
    }

    function getPrice() public {

    }

    function getConversionRate() public {

    }

    function getVersion() public view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}
