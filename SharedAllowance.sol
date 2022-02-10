//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "./Allowance.sol";

contract SharedWallet is Allowance {

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");

        /*This process doesn't work in updated version of solidity (written on v0.5.13)
        if(!owner) {
            reduceAllowance(msg.sender, _amount);
        } */

        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public pure override {
        revert("Can't renounce ownership here");
    }

    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
    receive() external payable {}
}