/* global ethers */
/* eslint prefer-const: "off" */

const hre = require("hardhat");
const diamond = require('../js/diamond-util/src/index.js')

async function deployTxFarm({
  accounts
}) {
  const contractOwner = accounts[0];
  let TxFarmDiamond = await diamond.deploy({
    diamondName: 'TxFarmDiamond',
    initDiamond: 'contracts/TxFarm/DiamondInit.sol:DiamondInit',
    facets: [
        'BlueprintFacet',
        'LandFacet',
    ],
    owner: contractOwner,
    args: [[
      accounts
    ]]
  })

  return {
    diamondAddress: TxFarmDiamond.address,
    contractOwner: contractOwner
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  hre.run("compile").then(deployTxFarm)
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployTxFarm = deployTxFarm
