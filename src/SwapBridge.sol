// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ITokenBridge} from "LayerZero-Aptos-Contract/apps/bridge-evm/contracts/interfaces/ITokenBridge.sol";
import {LzLib} from "@layerzerolabs/solidity-examples/contracts/libraries/LzLib.sol";

contract SwapBridge {
    uint256 constant APT_AIRDROP_AMOUNT = 9904;

    ITokenBridge immutable tokenBridge;

    constructor(address _tokenBridgeAddress) {
        tokenBridge = ITokenBridge(_tokenBridgeAddress);
    }

    function approveMax(IERC20 _token, address _spender) public {
        SafeERC20.forceApprove(_token, _spender, type(uint256).max);
    }

    function quoteForSend() public view returns (uint256 nativeFee, uint256 zroFee) {
        (LzLib.CallParams memory callParams, bytes memory adapterParams) = _lzParams(hex"01");
        (nativeFee, zroFee) = tokenBridge.quoteForSend(callParams, adapterParams);
    }

    function swapAndSendToAptos(
        IERC20 fromToken,
        uint256 fromAmount,
        IERC20 toToken,
        uint256 toAmount,
        bytes32 aptosAddress,
        address swapTarget,
        bytes calldata swapBytes
    ) public payable {
        uint256 actualToAmount;
        {
            SafeERC20.safeTransferFrom(fromToken, msg.sender, address(this), fromAmount);

            (bool success,) = swapTarget.call(swapBytes);
            require(success, "Swap failed");

            actualToAmount = toToken.balanceOf(address(this));
            require(actualToAmount >= toAmount, "toAmount");

            if (fromToken.balanceOf(address(this)) > 0) {
                SafeERC20.safeTransfer(fromToken, msg.sender, fromToken.balanceOf(address(this)));
            }
        }

        {
            SafeERC20.forceApprove(toToken, address(tokenBridge), type(uint256).max);
            (LzLib.CallParams memory callParams, bytes memory adapterParams) = _lzParams(aptosAddress);
            tokenBridge.sendToAptos{value: msg.value}(
                address(toToken), aptosAddress, toToken.balanceOf(address(this)), callParams, adapterParams
            );
        }

        require(toToken.balanceOf(address(this)) == 0, "toToken remaining");
    }

    function _lzParams(bytes32 aptosAddress)
        private
        view
        returns (LzLib.CallParams memory callParams, bytes memory adapterParams)
    {
        callParams = LzLib.CallParams({refundAddress: payable(msg.sender), zroPaymentAddress: address(0x0)});
        adapterParams = LzLib.buildAirdropAdapterParams(
            10000, // uaGas
            LzLib.AirdropParams({airdropAmount: APT_AIRDROP_AMOUNT, airdropAddress: aptosAddress})
        );
    }
}

// TODO layerzero msg 의 msg.sender 대신 tx 의 from 을 봐야 함 (tx.origin)
// TODO paraswap build tx 할 때 userAddress, txOrigin, receiver

// txType 2
// bytes  [2       32        32            bytes[]         ]
// fields [txType  extraGas  dstNativeAmt  dstNativeAddress]
// 0002
// 0000000000000000000000000000000000000000000000000000000000002710
// 0000000000000000000000000000000000000000000000000000000000000000
// 1cc57f0fe249bc7278c2e38e85a85ca6c9e0ee51b47ff073797c31702d93a4cb
