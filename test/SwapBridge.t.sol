// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {SwapBridge} from "../src/SwapBridge.sol";

contract SwapBridgeTest is Test {
    address constant usdtAddress = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address constant fromUser = 0x8558FE88F8439dDcd7453ccAd6671Dfd90657a32;

    // address constant oneInchAddress = ;

    SwapBridge public swapBridge;

    function setUp() public {
        uint256 mainnetForkBlock = 19_511_781;
        vm.createSelectFork(vm.rpcUrl("mainnet"), mainnetForkBlock);

        hoax(makeAddr("deployer"));
        swapBridge = new SwapBridge();
        assertEq(
            address(swapBridge),
            0x8Ad159a275AEE56fb2334DBb69036E9c7baCEe9b
        );
        // swapBridge.approveMax(usdtAddress);
        // swapBridge.swap(
        //     usdtAddress,
        //     1_000_000_000, // 1000 USDT
        //     usdcAddress,
        //     swapTarget,
        //     swapBytes
        // );
    }

    function test_ApproveMax() public {
        IERC20(usdtAddress).approve(address(swapBridge), type(uint256).max);
        // swapBridge.approveMax(usdtAddress, address(swapBridge));
    }

    function test_Increment() public {
        emit log_address(address(this));
    }
}
