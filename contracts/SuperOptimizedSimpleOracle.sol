// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SuperOptimizedOracle {
    // Struct to store the data provider's ID and temporary price
    struct DataProvider {
        uint id;
        uint tempPrice;
    }

    // Mapping that maps an address to a DataProvider struct
    mapping(address => DataProvider) public dataProviders;
    // An array that stores the addresses of all the accounts that have updated the price
    address[] public dataProviderAddresses;
    // Store the aggregated price
    uint public aggregatedPrice;

    // Updates the temporary price
    function updatePrice(uint newPrice) public {
        // Check if the data provider is registered
        require(dataProviders[msg.sender].id != 0, "Data provider not registered");
        // Update the temporary price for the data provider
        dataProviders[msg.sender].tempPrice = newPrice;
    }

    // Finalizes the aggregated price
    function finalizePrice() public {
        uint totalPrices = 0;

        for (uint i = 0; i < dataProviderAddresses.length; i++) {
            address dataProviderAddress = dataProviderAddresses[i];
            totalPrices += dataProviders[dataProviderAddress].tempPrice;
            // Clear the data provider's temporary price after use to free up storage space
            delete dataProviders[dataProviderAddress].tempPrice;
        }
        
        aggregatedPrice = totalPrices / dataProviderAddresses.length;
    }

    // Returns the aggregated price
    function getPrice() public view returns (uint) {
        return aggregatedPrice;
    }
}