// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "./interfaces/IERC20.sol";
import "./Vault.sol";

contract Rocket{
    bytes32 immutable public salt;
    constructor(bytes32 _salt) {
        salt = _salt;
    }

	function launch(address approvalTarget, address token, address receiver, uint256 amount) external {
        require(salt == keccak256(abi.encode( approvalTarget, token, receiver,amount)) ,"SALT MISMATCH");
		IERC20(token).approve(approvalTarget, amount);

		// INSERT YOUR APPLICATION CODE BELOW
        Vault(approvalTarget).deposit(amount, receiver);
	}
}