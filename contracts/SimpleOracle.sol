// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * SimpleOracle contract is a demonstration of a simple oracle that is NOT optimized for gas efficiency. 
 * It updates the storage with every price update, making it unsuitable for frequent storage reads and writes. 
 * This contract is meant to be used as a teaching tool to demonstrate how to optimize contracts that use shared storage. 
 * For optimized versions of this contract, see OptimizedSimpleOracle.sol and SuperOptimizedSimpleOracle.sol.
 */
contract SimpleOracle {
    mapping(address => uint) public prices;
    // An array that stores the addresses of all the accounts that have updated the price
    address[] public dataProviders;

    // Updates the price for the calling account
    function updatePrice(uint newPrice) public {
        prices[msg.sender] = newPrice;
    }

    // Returns the average price of all the data providers
    function getPrice() public view returns (uint) {
        uint totalPrices = 0;
        // Loop through all the data providers and add their prices to the totalPrices variable
        for (uint i = 0; i < dataProviders.length; i++) {
            totalPrices += prices[dataProviders[i]];
        }
        // Return the average price by dividing the totalPrices by the number of data providers
        return totalPrices / dataProviders.length;
    }
}