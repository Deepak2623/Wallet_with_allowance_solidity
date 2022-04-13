// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "./Allowance.sol";

contract SimpleWallet is Allowance {
    event Moneysent(address indexed _beneficary, uint256 _ammount);

    event MoneyReceived(address indexed _from, uint256 _ammount);

    function WithdrawFunds(address payable _to, uint256 _ammount)
        public
        AddAllowance(_ammount)
    {
        require(
            _ammount <= address(this).balance,
            "There is not enough funds storedm in the Smart Contract"
        );
        if (!isOwner()) {
            reduceAllowance(msg.sender, _ammount);
        }
        emit Moneysent(_to, _ammount);
        _to.transfer(_ammount);
    }

    function renounceOwnership() public view override onlyOwner {
        revert("cant renounce ownership");
    }

    function funding() external payable {
        require(msg.value > 0, " cant be zero");
        emit MoneyReceived(msg.sender, msg.value);
    }
}
