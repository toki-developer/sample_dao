//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface iTkoToken {

    //******************************
    // admin functions
    //******************************

    function withdrawETH() external;
    function setRecipient(address payable __recipient) external;
}