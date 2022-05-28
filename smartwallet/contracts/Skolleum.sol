pragma solidity ^0.4.24;

import "./MeterManagement.sol";

// Bottom most child contract conforming to ERC20 token standard
contract Skolleum is MeterManagement {
    string public name = "Skolleum: 1 token = 1kWh";
    string public symbol = "Skolleum";
    uint8 public decimals = 6; // Defines number of decimal places for Krag Token 
    
    
    constructor() public {
        totalSupply_ = 0; // Initializes total token supply to 0 upon intial deployment
    }
}