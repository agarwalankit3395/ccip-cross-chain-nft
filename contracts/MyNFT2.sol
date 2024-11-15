// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract MyNFT2 is ERC721URIStorage, Ownable {
    string constant TOKEN_URI =
        "https://ipfs.io/ipfs/QmYuKY45Aq87LeL1R5dhb1hqHLp6ZFbJaCP8jxqKM1MX6y/babe_ruth_1.json";
    uint256 internal tokenId;

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}

    function mint(address to, uint256 _tokenId) public {
        _safeMint(to, _tokenId);
        _setTokenURI(_tokenId, TOKEN_URI);
    }

    function mint(address to) public {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, TOKEN_URI);
        unchecked {
            tokenId++;
        }
    }
}
