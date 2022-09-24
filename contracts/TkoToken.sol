//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./iTkoToken.sol";

contract TkoToken is iTkoToken, ERC721, Ownable {
    address payable private _recipient;
    constructor(address payable __recipient) ERC721("TkoToken", "TKO") {
        require(__recipient != address(0), "TkoToken: Invalid address");
        _recipient = __recipient;
    }

    //******************************
    // admin functions
    //******************************

    function withdrawETH() external override onlyOwner {
        Address.sendValue(_recipient, address(this).balance);
    }

    function setRecipient(address payable __recipient) external onlyOwner {
        _recipient = __recipient;
    }
}

