//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface iTkoToken {

    //******************************
    // view functions
    //******************************

    function isOnSale() external view returns (bool);
    function nextTokenId(uint256 rank) external view returns (uint256);

    //******************************
    // public functions
    //******************************

    function buy(uint256 rank) external payable;

    //******************************
    // admin functions
    //******************************

    function updateSaleStatus(bool __isOnSale) external;
    // function updateBaseURI(string calldata newBaseURI) external;
    // function freezeMetadata() external;
    function withdrawETH() external;
    function setRecipient(address payable __recipient) external;
}