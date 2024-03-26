// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "forge-std/console.sol";

contract SwapBridge {
    function approveMax(IERC20 token, address spender) public {
        SafeERC20.forceApprove(token, spender, type(uint256).max);
    }

    function swap(
        IERC20 fromToken,
        uint256 fromAmount,
        IERC20 toToken,
        address swapTarget,
        bytes calldata swapBytes
    ) public {
        SafeERC20.safeTransferFrom(
            fromToken,
            msg.sender,
            address(this),
            fromAmount
        );

        SafeERC20.forceApprove(fromToken, swapTarget, type(uint256).max);
        (bool success, ) = swapTarget.call(swapBytes);
        require(success, "Swap failed");

        SafeERC20.safeTransfer(fromToken, msg.sender, fromToken.balanceOf(address(this)));
        SafeERC20.safeTransfer(toToken, msg.sender, toToken.balanceOf(address(this)));
    }

    function swapAndSendToAptos(
        IERC20 fromToken,
        uint256 fromAmount,
        IERC20 toToken,
        uint256 toAmount,
        address swapTarget,
        bytes calldata swapBytes
    ) public {
        swap(fromToken, fromAmount, toToken, swapTarget, swapBytes);

    }

}
