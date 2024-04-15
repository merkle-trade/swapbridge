// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {ITokenBridge} from "LayerZero-Aptos-Contract/apps/bridge-evm/contracts/interfaces/ITokenBridge.sol";
import {LzLib} from "@layerzerolabs/solidity-examples/contracts/libraries/LzLib.sol";

contract SwapBridge is Ownable {
    uint256 constant APT_AIRDROP_AMOUNT = 9904;

    bool isInit;
    ITokenBridge tokenBridge;

    constructor(address _tokenBridgeAddress) Ownable(_msgSender()) {
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
        IERC20 _fromToken,
        uint256 _fromAmount,
        IERC20 _toToken,
        uint256 _toAmount,
        bytes32 _aptosAddress,
        address _swapTarget,
        bytes calldata _swapBytes
    ) public payable {
        SafeERC20.safeTransferFrom(_fromToken, msg.sender, address(this), _fromAmount);

        Address.functionCall(_swapTarget, _swapBytes);

        uint256 actualToAmount = _toToken.balanceOf(address(this));
        require(actualToAmount >= _toAmount, "toAmount");

        uint256 residue = _fromToken.balanceOf(address(this));
        if (residue > 0) {
            SafeERC20.safeTransfer(_fromToken, msg.sender, residue);
        }

        (LzLib.CallParams memory callParams, bytes memory adapterParams) = _lzParams(_aptosAddress);
        tokenBridge.sendToAptos{value: msg.value}(
            address(_toToken), _aptosAddress, actualToAmount, callParams, adapterParams
        );

        require(_toToken.balanceOf(address(this)) == 0, "toToken remaining");
    }

    function rescueToken(IERC20 _token, address _recipient) external onlyOwner {
        uint256 tokenBalance = _token.balanceOf(address(this));
        require(tokenBalance > 0, "Nothing to rescue");
        SafeERC20.safeTransfer(_token, _recipient, tokenBalance);
    }

    function _lzParams(bytes32 _aptosAddress)
        private
        view
        returns (LzLib.CallParams memory callParams, bytes memory adapterParams)
    {
        callParams = LzLib.CallParams({refundAddress: payable(msg.sender), zroPaymentAddress: address(0x0)});
        adapterParams = LzLib.buildAirdropAdapterParams(
            10000, // uaGas
            LzLib.AirdropParams({airdropAmount: APT_AIRDROP_AMOUNT, airdropAddress: _aptosAddress})
        );
    }
}

// TODO layerzero msg 의 msg.sender 대신 tx 의 from 을 봐야 함 (tx.origin)
