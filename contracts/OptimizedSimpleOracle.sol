// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * OptimizedSimpleOracle contract is a slightly more optimized version of a simple oracle that is more suitable for gas efficiency. 
 * It uses temporary storage to store the prices and clears the storage after use to free up space. 
 * This contract is meant to be used as a teaching tool to demonstrate how to optimize contracts that use shared storage. 
 * For a more optimized version of this contract, see SuperOptimizedSimpleOracle.sol.
 */
contract OptimizedSimpleOracle {
    mapping(address => uint) public temporaryPrices;
    // An array that stores the addresses of all the accounts that have updated the price
    address[] public dataProviders;
    // Store the aggregated price
    uint public aggregatedPrice;

    // Updates the temporary price 
    function updatePrice(uint newPrice) public {
        temporaryPrices[msg.sender] = newPrice;
    }

    // Finalizes the aggregated price
    function finalizePrice() public {
        uint totalPrices = 0;
    
        for (uint i = 0; i < dataProviders.length; i++) {
            totalPrices += temporaryPrices[dataProviders[i]];
            // Clear the temporary price after use to free up storage space
            delete temporaryPrices[dataProviders[i]];
        }
        
        aggregatedPrice = totalPrices / dataProviders.length;
    }

    // Returns the aggregated price
    function getPrice() public view returns (uint) {
        return aggregatedPrice;
    }
}