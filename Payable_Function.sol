// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayableFunctionDemo{

    function sendEthers(address payable recipient) external payable {
        recipient.transfer(5 ether);
    }
}