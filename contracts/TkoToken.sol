//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./iTkoToken.sol";

contract TkoToken is iTkoToken, ERC721, Ownable, ReentrancyGuard {

    using Strings for uint256;

    uint256 public constant PRICE = 0.03 ether;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 private _remainingReserved = 100;
    uint256 private nextTokenId = 1;
    address payable private _recipient;
    bool private _isOnSale;
    constructor(address payable __recipient) ERC721("TkoToken", "TKO") {
        require(__recipient != address(0), "TkoToken: Invalid address");
        _recipient = __recipient;
    }

    modifier onSale() {
        require(_isOnSale, "TkoToken: Not on sale");
        _;
    }

    //******************************
    // view functions
    //******************************

    function remainingForSale() external view override returns (uint256){
        return MAX_SUPPLY - _remainingReserved - (nextTokenId - 1);
    }

    function remainingReserved() external view override returns (uint256) {
        return _remainingReserved;
    }

    function isOnSale() external view override returns (bool) {
        return _isOnSale;
    }


    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        require(_exists(tokenId), "TkoToken: URI query for nonexistent token");

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(bytes(abi.encodePacked('{"name":"TkoToken #',  Strings.toString(tokenId),'","description": "This is Tko Token","image": "https://gr2v2wtpgux5jwj5aq6vwu5iaoxv5vub5fihr5ul3irmp3rvie7a.arweave.net/NHVdWm81L9TZPQQ9W1OoA69e1oHpUHj2i9oix-41QT4"}')))
            )
        );
    }

    //******************************
    // public functions
    //******************************

    function buy() external override onSale nonReentrant payable {
        require(msg.value == PRICE, "TkoToken: Invalid value");
        require((nextTokenId + _remainingReserved) < MAX_SUPPLY, "TkoToken: Sold out");
        uint256 tokenId = nextTokenId;
        nextTokenId ++;
        _safeMint(_msgSender(), tokenId);
    }

    //******************************
    // admin functions
    //******************************


    function mintReserved(address to) external override onlyOwner {
        require(_remainingReserved > 0, "No reserved Token is left");
        uint256 tokenId = nextTokenId;
        nextTokenId ++;
        _remainingReserved --;
        _safeMint(to, tokenId);
    }

     function updateSaleStatus(bool __isOnSale) external override onlyOwner {
        _isOnSale = __isOnSale;
    }

    function withdrawETH() external override onlyOwner {
        Address.sendValue(_recipient, address(this).balance);
    }

    function setRecipient(address payable __recipient) external override onlyOwner {
        _recipient = __recipient;
    }
}

