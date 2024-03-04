// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//Import for Remix 
import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

    function getPrice() internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();    
        //We must multiply by 1e10 because the "priceFeed.latestRoundData()" returns a number with 8 decimals
        // and we must manipulate 18 decimals
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        //ethPrice is with 18 decimals
        //ethAmount is with 18 decimals
        // So we divide by 10^18 to get a number with 18 decimals
        uint256 ethAmountInUsd =  (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

}