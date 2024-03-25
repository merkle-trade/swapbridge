// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract SwapBridge {
    function approveMax(address erc20, address spender) public {
        bool approved = IERC20(erc20).approve(spender, type(uint256).max);
        require(approved, "ERC20 approve failed");
    }

    function swap(
        address fromToken,
        uint256 fromAmount,
        address toToken,
        address swapTarget,
        bytes calldata swapBytes
    ) public {
        IERC20 from = IERC20(fromToken);
        IERC20 to = IERC20(toToken);

        from.transferFrom(msg.sender, address(this), fromAmount);

        (bool success, ) = swapTarget.call(swapBytes);
        require(success, "Swap failed");

        from.transfer(msg.sender, from.balanceOf(address(this)));
        to.transfer(msg.sender, to.balanceOf(address(this)));
    }
}
