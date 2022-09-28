//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface iTkoToken {

    //******************************
    // view functions
    //******************************

    function remainingForSale() external view returns (uint256);
    function remainingReserved() external view returns (uint256);
    function isOnSale() external view returns (bool);

    //******************************
    // public functions
    //******************************

    function buy() external payable;

    //******************************
    // admin functions
    //******************************

    function updateSaleStatus(bool __isOnSale) external;
    function withdrawETH() external;
    function setRecipient(address payable __recipient) external;
}