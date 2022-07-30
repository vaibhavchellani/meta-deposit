// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./Rocket.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import "./RocketFactory.sol";
import "./Vault.sol";

contract RocketTest is Test {
	uint256 optimismFork;
	address dummyVault;
	address USDC_HOLDER = 0xB589969D38CE76D3d7AA319De7133bC9755fD840;
	address USDC = 0x7F5c764cBc14f9669B88837ca1490cCa17c31607;
	
	// 100 USDC
	uint256 amount = 100000000;

	// original USER
	address user = 0x75bbC04fA183dd0ac75857a0400F93f766748f01;

    function setUp() public {
		optimismFork = vm.createSelectFork(<enter RPC>);
		dummyVault = address(new Vault(ERC20(USDC), "socketrocket", "socketrocket"));
    }

    function testLaunch() public {
		address  APPROVAL_TARGET = dummyVault;

		// deploy RocketFactory
		RocketFactory rocketFactory = new RocketFactory();
		address predictedAddress = rocketFactory.getAddressFor(APPROVAL_TARGET, USDC, user, amount);

		// tranfer USDC to the predicted Rocket
		vm.prank(USDC_HOLDER);
		ERC20(USDC).transfer(predictedAddress, amount);

		// deploy Rocket
		address newRocket = rocketFactory.deploy(APPROVAL_TARGET, USDC, user, amount);

		// call launch 
		Rocket(newRocket).launch(APPROVAL_TARGET, USDC, user, amount);
    }
}
