// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

struct MapPosition {
    uint256 itemId;
    uint8 x;
    uint8 y;
    bool isRotated;
}

struct Land {
    uint256 id;
    uint256[100][100] plots;
    mapping(uint256 => uint256) plotStatus;
    // mapping(uint256 => uint256) plotFilled;
    EnumerableSet.UintSet holdingItemIds;
    uint32 landMapId;
}

struct LandStorage {
    mapping(uint256 => Land) lands;
    uint256 cowStableSlotUnlockPrice;
    uint256 chickenCoopSlotUnlockPrice;
    uint32 maxCropHarvestableTimes;
    // uint256 initLandPrice;
    mapping(uint32 => mapping(uint256 => uint256)) landMaps;
}
