// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {LandStorage, Land} from "../../shared/storage/LandStorage.sol";
import {ConfigStorage} from "../../shared/storage/ConfigStorage.sol";
import {UserProfileStorage} from "../../shared/storage/UserProfileStorage.sol";
import {Bits} from "./Bits.sol";
import {LibUserProfile} from "./LibUserProfile.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library LibLand {
    using Bits for uint;
    using EnumerableSet for EnumerableSet.UintSet;

    uint256 private constant ID_NO_SEED = 0;
    uint256 private constant ID_DEFAULT_GIFT_SEED = 1;
    event LandInitiated(uint256 indexed _landId, address indexed _farmer);

    function isPlotActive(
        Land storage _land,
        uint8 _plotPostionX,
        uint8 _plotPositionY
    ) internal view returns (bool) {
        return _land.plotStatus[_plotPostionX].bitSet(255 - _plotPositionY);
    }

    // function isPlotFilled(
    //     Land storage _land,
    //     uint8 _plotPostionX,
    //     uint8 _plotPositionY
    // ) internal view returns (bool) {
    //     return _land.plotFilled[_plotPostionX].bitSet(255 - _plotPositionY);
    // }

    function getTotalLand() internal view returns (uint256) {
        ConfigStorage storage cs = LibAppStorage.configStorage();
        require(address(cs.txFarmLandContract) != address(0), "LibLand: land contract not set");
        return cs.txFarmLandContract.totalSupply();
    }

    function getLandOwner(uint256 _landId) internal view returns (address) {
        ConfigStorage storage cs = LibAppStorage.configStorage();
        require(address(cs.txFarmLandContract) != address(0), "LibLand: land contract not set");
        return cs.txFarmLandContract.ownerOf(_landId);
    }

    function getLandsOfOwner(address _owner) internal view returns (uint256[] memory) {
        ConfigStorage storage cs = LibAppStorage.configStorage();
        require(address(cs.txFarmLandContract) != address(0), "LibLand: land contract not set");
        uint256 totalLand = cs.txFarmLandContract.balanceOf(_owner);
        uint256[] memory landIds = new uint256[](totalLand);
        for (uint256 i = 0; i < totalLand; i++) {
            landIds[i] = cs.txFarmLandContract.tokenOfOwnerByIndex(_owner, i);
        }
        return landIds;
    }

    function initLand() internal {
        LandStorage storage ls = LibAppStorage.landStorage();
        ConfigStorage storage cs = LibAppStorage.configStorage();
        UserProfileStorage storage ups = LibAppStorage.userProfileStorage();
        
        // require(ls.initLandPrice > 0, "LibLand: init land price not set");
        // require(msg.value >= ls.initLandPrice, "LibLand: insufficient funds");
        require(
            ups.isInitialized[msg.sender] == false,
            "LibLand: user already initiated"
        );
        ups.isInitialized[msg.sender] = true;
        ups.totalUsers++;
        uint256 newLandId = LibLand.getTotalLand() + 1;
        cs.txFarmLandContract.mint(msg.sender, newLandId, true);
        Land storage newLand = ls.lands[newLandId];
        newLand.id = newLandId;
        //Random landmap from 0 to 2
        newLand.landMapId = uint32(newLandId) % 3;
        LibUserProfile.initUserProfile(msg.sender);
        emit LandInitiated(newLandId, msg.sender);
    }
}
