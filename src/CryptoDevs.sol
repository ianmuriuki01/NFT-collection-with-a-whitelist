//SPDX-License-Identifier:MIT
pragma solidity ^0.8.30;

import {ERC721Enumerable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    //cost of one Crypto Dev NFT
    uint256 public constant _price = 0.01 ether;

    //max number of crypto that can ever exist
    uint256 public constant maxTokenIds = 20;

    //Whitelist instance
    Whitelist whitelist;

    //number of tokens reserved for whitelisted members
    uint256 public reservedTokens;
    uint256 reservedTokensClaimed = 0;

    constructor(address whitelistContract) ERC721("Crypto Devs", "CD") Ownable(msg.sender) {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.maxWhitelistedAddresses();
    }

    function mint() public payable {
        //make sure we always leave  enough room for whitelist reservations
        require(totalSupply() + reservedTokens - reservedTokensClaimed < maxTokenIds, "EXCEEDED_MAX_SUPPLY");
        //if user is part of the whitelist, make sure there is still reserved tokens left
        if (whitelist.whitelistedAddresses(msg.sender) && msg.value < _price) {
            //make sure user does not already own an NFT
            require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");
            reservedTokensClaimed += 1;
        } else {
            //if user is not part of the whitelist, make sure they have sent enough ETH
            require(msg.value >= _price, "NOT_ENOUGH_ETHER");
        }
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
