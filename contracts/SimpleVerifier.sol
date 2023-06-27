// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0; 

/**
 * Verifier contract is a simple contract that mimics verifying a proof represented by an array of data. 
 * It checks that the proof is not empty and returns a boolean value indicating whether the proof is valid or not. 
 * This contract is meant to be used as a teaching tool. 
 */
contract Verifier { 
    // Verifies a proof (represented by an array of data) 
    function verifyProof(uint[] calldata proof) public pure returns (bool) { 
        // For simplicity, we'll just check that the proof is not empty 
        return proof.length > 0; 
    } 
}



