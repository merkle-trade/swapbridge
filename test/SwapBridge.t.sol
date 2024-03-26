// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Test, console} from "forge-std/Test.sol";
import {SwapBridge} from "../src/SwapBridge.sol";

contract SwapBridgeTest is Test {
    IERC20 constant usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IERC20 constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    address constant fromUser = 0x8558FE88F8439dDcd7453ccAd6671Dfd90657a32; // some rich guy with 8-digit USDT blance
    address constant lzTokenBridge = 0x50002CdFe7CCb0C41F519c6Eb0653158d11cd907;
    address constant paraswapAugustusSwapper = 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;
    address constant paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

    address deployer;

    SwapBridge public swapBridge;

    function setUp() public {
        uint256 mainnetForkBlock = 19_516_762;
        vm.createSelectFork(vm.rpcUrl("mainnet"), mainnetForkBlock);

        deployer = makeAddr("deployer");
        assertEq(deployer, 0xaE0bDc4eEAC5E950B67C6819B118761CaAF61946);

        hoax(deployer);
        swapBridge = new SwapBridge(lzTokenBridge);
        assertEq(address(swapBridge), 0x8Ad159a275AEE56fb2334DBb69036E9c7baCEe9b);

        // fromUser
        assertGt(usdt.balanceOf(fromUser), 100_000_000_000);
        assertEq(usdc.balanceOf(fromUser), 0);
    }

    function test_SwapAndSendToAptos_ParaSwap() public {
        swapBridge.approveMax(usdt, paraswapTokenTransferProxy);
        (uint256 nativeFee,) = swapBridge.quoteForSend();

        startHoax(fromUser);
        SafeERC20.safeIncreaseAllowance(usdt, address(swapBridge), 1_000_000_000);
        swapBridge.swapAndSendToAptos{value: nativeFee}(
            usdt,
            1_000_000_000, // 1000 USDT
            usdc,
            990_000_000,
            hex"01",
            paraswapAugustusSwapper,
            hex"0b86a4c1000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000003b9aca00000000000000000000000000000000000000000000000000000000003b689ce1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000001000000000000000000004de53041cbd36888becc7bbcbc0045e3b1f144466f5f"
        );
        assertEq(address(swapBridge).balance, 0);
        assertEq(usdc.balanceOf(fromUser), 0);
        assertEq(usdt.balanceOf(address(swapBridge)), 0);
        assertEq(usdc.balanceOf(address(swapBridge)), 0);
    }

    function test_Swap_ParaSwap_toAmount() public {
        swapBridge.approveMax(usdt, paraswapTokenTransferProxy);
        (uint256 nativeFee,) = swapBridge.quoteForSend();

        startHoax(fromUser);
        SafeERC20.safeIncreaseAllowance(usdt, address(swapBridge), 1_000_000_000);
        vm.expectRevert("toAmount");
        swapBridge.swapAndSendToAptos{value: nativeFee}(
            usdt,
            1_000_000_000, // 1000 USDT
            usdc,
            10_000_000_000,
            hex"01",
            paraswapAugustusSwapper,
            hex"0b86a4c1000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000003b9aca00000000000000000000000000000000000000000000000000000000003b689ce1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000001000000000000000000004de53041cbd36888becc7bbcbc0045e3b1f144466f5f"
        );
    }
}
