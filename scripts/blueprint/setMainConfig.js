const hre = require("hardhat");
const dotenv = require('dotenv');
const { ethers } = require('hardhat');
const orderList = require("./order_list.json");
const _ = require('lodash');
const { deployNfts } = require('./deployNfts');
// const { craftProducts } = require('./craft_products.js');
const landMaps = require('./land_maps.json');
const welcomeItems = require('./welcome_items.json');
async function setMainConfig(blueprintAcc, diamondAddress) {
  let blueprint = await hre.ethers.getContractAt('BlueprintFacet', diamondAddress);
  
  for(let landMap of landMaps){
    tx = await blueprint.connect(blueprintAcc).setLandMap(
      landMap.id.toString(),
      landMap.indexes.map(index => index.toString()),
      landMap.values.map(value => value.toString())
    );
    await tx.wait();
    console.log(`setLandMap ${landMap.id} done`);
  }

  //Deploy nfts
  let {
    TxFarmLand,
  } = await deployNfts(diamondAddress);

  tx = await blueprint.connect(blueprintAcc).setTxFarmLandContract(
    TxFarmLand
  );
  await tx.wait();
  console.log('setTxFarmLandContract done');
}
exports.setMainConfig = setMainConfig;