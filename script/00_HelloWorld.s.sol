// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Script} from "forge-std/Script.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

abstract contract DeployScript is Script {
    bytes32 constant SALT = hex"fa1d23fff7";

    function run() public {
        vm.startBroadcast();
        new HelloWorld{salt: SALT}();
        vm.stopBroadcast();
    }
}

contract DeployScript_Sepolia is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
    }
}

contract DeployScript_Mainnet is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("mainnet"));
    }
}

contract DeployScript_Bsc is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("bsc"));
    }
}

contract DeployScript_Bsc_Testnet is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("bsc-testnet"));
    }
}

contract DeployScript_Polygon is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("polygon"));
    }
}

contract DeployScript_Polygon_Amoy is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("polygon-amoy"));
    }
}

contract DeployScript_Avalanche is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("avalanche"));
    }
}

contract DeployScript_Avalanche_Fuji is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("avalanche-fuji"));
    }
}

contract DeployScript_Arbitrum is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("arbitrum"));
    }
}

contract DeployScript_Arbitrum_Sepolia is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("arbitrum-sepolia"));
    }
}

contract DeployScript_Optimism is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("optimism"));
    }
}

contract DeployScript_Optimism_Sepolia is DeployScript {
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("optimism-sepolia"));
    }
}
