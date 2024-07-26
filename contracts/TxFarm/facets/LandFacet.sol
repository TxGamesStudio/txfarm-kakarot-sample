// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AppStorage, LibAppStorage, Modifiers} from "../libraries/LibAppStorage.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibLand} from "../libraries/LibLand.sol";
import {LandStorage, Land} from "../../shared/storage/LandStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "hardhat/console.sol";

contract LandFacet is Modifiers {

    using EnumerableSet for EnumerableSet.UintSet;

    uint256 private constant ID_INACTIVE = 0;
    uint256 private constant ID_ACTIVE = 1;

    event LandInitiated(uint256 indexed _landId, address indexed _farmer);

    function initLand() external payable {
        LibLand.initLand();
    }

    function getLand(
        uint256 _landId,
        uint256 _start,
        uint256 _offset
    ) external view returns (address owner, uint32 landMapId, string[] memory _map) {
        LandStorage storage ls = LibAppStorage.landStorage();
        Land storage land = ls.lands[_landId];
        string[] memory map = new string[](100);
        for (uint8 i; i < 100; i++) {
            uint256 row0Value = land.plots[i][0];
            if (
                land.plots[i][0] == ID_INACTIVE &&
                LibLand.isPlotActive(land, i, 0)
            ) {
                row0Value = ID_ACTIVE;
            }
            string memory row = Strings.toString(row0Value);
            for (uint8 j = 1; j < 100; j++) {
                uint256 plotValue = land.plots[i][j];
                if (
                    land.plots[i][j] == ID_INACTIVE &&
                    LibLand.isPlotActive(land, i, j)
                ) {
                    plotValue = ID_ACTIVE;
                }
                row = string(
                    abi.encodePacked(row, ",", Strings.toString(plotValue))
                );
            }
            map[i] = row;
        }
        string[] memory returnMap = new string[](_offset);
        for (uint256 i; i < _offset; i++) {
            returnMap[i] = map[_start + i];
        }
        return (LibLand.getLandOwner(_landId), land.landMapId, returnMap);
    }

    function getLand2(
        uint256 _landId,
        uint8 _skip,
        uint8 _limit
    ) external view returns (address owner, uint256[][] memory _map) {
        LandStorage storage ls = LibAppStorage.landStorage();
        Land storage land = ls.lands[_landId];
        uint256[][] memory map = new uint256[][](_limit);
        
        for (uint8 i; i < _limit; i++) {
            uint8 index = i + _skip;
            uint256[] memory row = new uint256[](100);
            for (uint8 j = 0; j < 100; j++) {
                row[j] = land.plots[index][j];
                if (
                    land.plots[index][j] == ID_INACTIVE &&
                    LibLand.isPlotActive(land, index, j)
                ) {
                    row[j] = ID_ACTIVE;
                }
            }
            map[i] = row;
        }
        return (LibLand.getLandOwner(_landId), map);
    }
}
