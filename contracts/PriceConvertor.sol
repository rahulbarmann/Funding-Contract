// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    function getPrice(address _priceFeedAddress) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            _priceFeedAddress
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    // The first var that gets passed to the function as a parameter is going to be the object that its called on itself
    function priceConvertor(
        uint256 _ethAmount,
        address _priceFeedAddress
    ) internal view returns (uint256) {
        // Libraries are only embedded into the contract if the library functions are internal.... so they must be internal. As we are calling this function in fundMe so this must be internal
        uint ethPrice = getPrice(_priceFeedAddress);
        uint ethAmountInUsd = (_ethAmount * ethPrice) / 1e18;
        return ethAmountInUsd;
    }
}
