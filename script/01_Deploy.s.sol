// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SwapBridge} from "../src/SwapBridge.sol";

abstract contract DeployScript is Script {
    bytes32 constant SALT = hex"fa1d23fff8";
}

contract DeployScript_Sepolia is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
    }

    function run() public {
        address lzTokenBridge = 0x50002CdFe7CCb0C41F519c6Eb0653158d11cd907;
        IERC20 usdc = IERC20(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}

contract DeployScript_Mainnet is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("mainnet"));
    }

    function run() public {
        address lzTokenBridge = 0x50002CdFe7CCb0C41F519c6Eb0653158d11cd907;
        IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        address paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        swapBridge.approveMax(IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7), paraswapTokenTransferProxy); // USDT
        swapBridge.approveMax(IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F), paraswapTokenTransferProxy); // DAI
        swapBridge.approveMax(IERC20(0xc5f0f7b66764F6ec8C8Dff7BA683102295E16409), paraswapTokenTransferProxy); // FDUSD
        swapBridge.approveMax(IERC20(0x4c9EDD5852cd905f086C759E8383e09bff1E68B3), paraswapTokenTransferProxy); // USDe (Ethena USD)
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}

contract DeployScript_Bsc is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("bsc"));
    }

    function run() public {
        address lzTokenBridge = 0x2762409Baa1804D94D8c0bCFF8400B78Bf915D5B;
        IERC20 usdc = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
        address paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        swapBridge.approveMax(IERC20(0x55d398326f99059fF775485246999027B3197955), paraswapTokenTransferProxy); // USDT
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}

contract DeployScript_Polygon is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("polygon"));
    }

    function run() public {
        address lzTokenBridge = 0x488863D609F3A673875a914fBeE7508a1DE45eC6;
        IERC20 usdc = IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
        address paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        swapBridge.approveMax(IERC20(0xc2132D05D31c914a87C6611C10748AEb04B58e8F), paraswapTokenTransferProxy); // USDT
        swapBridge.approveMax(IERC20(0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359), paraswapTokenTransferProxy); // USDC
        swapBridge.approveMax(IERC20(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063), paraswapTokenTransferProxy); // DAI
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}

contract DeployScript_Avalanche is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("avalanche"));
    }

    function run() public {
        address lzTokenBridge = 0xA5972EeE0C9B5bBb89a5B16D1d65f94c9EF25166;
        IERC20 usdc = IERC20(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E);
        address paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        swapBridge.approveMax(IERC20(0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7), paraswapTokenTransferProxy); // USDT
        swapBridge.approveMax(IERC20(0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664), paraswapTokenTransferProxy); // USDC.e
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}

contract DeployScript_Arbitrum is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("arbitrum"));
    }

    function run() public {
        address lzTokenBridge = 0x1BAcC2205312534375c8d1801C27D28370656cFf;
        IERC20 usdc = IERC20(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
        address paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        swapBridge.approveMax(IERC20(0xaf88d065e77c8cC2239327C5EDb3A432268e5831), paraswapTokenTransferProxy); // USDC
        swapBridge.approveMax(IERC20(0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9), paraswapTokenTransferProxy); // USDT
        swapBridge.approveMax(IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1), paraswapTokenTransferProxy); // DAI
        swapBridge.approveMax(IERC20(0xFEa7a6a0B346362BF88A9e4A88416B77a57D6c2A), paraswapTokenTransferProxy); // MIM
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}

contract DeployScript_Optimism is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("optimism"));
    }

    function run() public {
        address lzTokenBridge = 0x86Bb63148d17d445Ed5398ef26Aa05Bf76dD5b59;
        IERC20 usdc = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);
        address paraswapTokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

        vm.startBroadcast();
        SwapBridge swapBridge = new SwapBridge{salt: SALT}();
        swapBridge.initialize(lzTokenBridge);
        swapBridge.approveMax(usdc, lzTokenBridge);
        swapBridge.approveMax(IERC20(0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85), paraswapTokenTransferProxy); // USDC
        swapBridge.approveMax(IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1), paraswapTokenTransferProxy); // DAI
        swapBridge.approveMax(IERC20(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58), paraswapTokenTransferProxy); // USDT
        vm.stopBroadcast();

        console.logAddress(address(swapBridge));
    }
}
