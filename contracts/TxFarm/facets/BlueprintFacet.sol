// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import {AppStorage, Modifiers} from "../libraries/LibAppStorage.sol";
import {LibBlueprint} from "../libraries/LibBlueprint.sol";
import {LibAppStorage} from "../libraries/LibAppStorage.sol";
import {LandStorage} from "../../shared/storage/LandStorage.sol";
import {LibLand} from "../libraries/LibLand.sol";
import {ITxFarmLand} from "../../shared/interfaces/ITxFarmLand.sol";
import {ConfigStorage} from "../../shared/storage/ConfigStorage.sol";

contract BlueprintFacet is Modifiers {
    function setTxFarmLandContract(address _txFarmLandContract) external {
        ConfigStorage storage cs = LibAppStorage.configStorage();
        cs.txFarmLandContract = ITxFarmLand(_txFarmLandContract);
    }
    function setLandMap(uint32 _landType, uint256[] memory _indexs, uint256[] memory _values) external {
        require(_indexs.length == _values.length, "BlueprintFacet: _indexs and _values length mismatch");
        for (uint256 i; i < _indexs.length; i++) {
            LibAppStorage.landStorage().landMaps[_landType][_indexs[i]] = _values[i];
        }
    }
    
}
