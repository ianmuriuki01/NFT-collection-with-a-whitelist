//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

contract Whitelist {
    //number of whitelisted addresses
    uint8 public numAddressesWhitelisted;
    //max number of whitelisted addresses
    uint8 public maxWhitelistedAddresses;
    //mapping of whitelisted addresses
    mapping(address => bool) public whitelistedAddresses;

    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }
    //function to add address to whitelist

    function addAddressToWhitelist() public {
        //check whether address is in whitelist
        require(!whitelistedAddresses[msg.sender], "Address already in the whitelist");
        //check whether number of addresses in whitelist is < 10
        require(numAddressesWhitelisted < maxWhitelistedAddresses, "Whitelist already full.");
        //add address to the whitelist
        whitelistedAddresses[msg.sender] = true;
        //update the number of addresses in the white list
        numAddressesWhitelisted += 1;
    }
}
