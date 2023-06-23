// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Counter {
    uint public counter;

    function incrementCounterManyTimes(uint times) public {
        for(uint i = 0; i < times; i++) {
            counter++;
        }
    }
}