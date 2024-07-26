// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LandStorage } from "../../shared/storage/LandStorage.sol";
import { RegistryStorage } from "../../shared/storage/RegistryStorage.sol";
import { UserProfileStorage } from "../../shared/storage/UserProfileStorage.sol";
import { ConfigStorage } from "../../shared/storage/ConfigStorage.sol";

import { LibDiamond } from "../../shared/libraries/LibDiamond.sol";
import { LibMeta } from "../../shared/libraries/LibMeta.sol";

import { Counters } from "@openzeppelin/contracts/utils/Counters.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

struct AppStorage {
    uint256 version;
}

library LibAppStorage {
    bytes32 public constant LandStorage_STORAGE_POSITION = keccak256("LandStorage.storage.position");
    bytes32 public constant RegistryStorage_STORAGE_POSITION = keccak256("RegistryStorage.storage.position"); 
    bytes32 public constant UserProfileStorage_STORAGE_POSITION = keccak256("UserProfileStorage.storage.position");
    bytes32 public constant ConfigStorage_STORAGE_POSITION = keccak256("ConfigStorage.storage.position");



    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }

    function landStorage() internal pure returns(LandStorage storage ds) {
        bytes32 position = LandStorage_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function registryStorage() internal pure returns(RegistryStorage storage ds) {
        bytes32 position = RegistryStorage_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function userProfileStorage() internal pure returns(UserProfileStorage storage ds) {
        bytes32 position = UserProfileStorage_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function configStorage() internal pure returns(ConfigStorage storage ds) {
        bytes32 position = ConfigStorage_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }
}

contract Modifiers {
    AppStorage internal s;

    modifier onlyFromDiamond() {
        require(msg.sender == address(this), "internal call only!");
        _;
    }

    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }
}
