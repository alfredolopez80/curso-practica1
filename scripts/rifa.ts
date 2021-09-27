// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { run, ethers, web3 } from 'hardhat'
import { BigNumber } from 'ethers'
import { abi } from '../artifacts/contracts/Rifa.sol/Rifa.json'

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  await run('compile')
  //VRF Coordinator Value for Mumbai Chain - Polygon Testnet
  const vrfCoordinator = '0x8C7382F9D8f56b33781fE506E897a4F1e2d17255'
  const linkToken = '0x326C977E6efc84E512bB9C30f76E30c160eD06FB'
  const keyHash =
    '0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4'
  const fee = ethers.utils.parseEther('0.0005');

  console.log('Constructor Value: ',"\'" ,vrfCoordinator ,"\' " ,"\'", linkToken,"\' ", "\'" , keyHash,"\' ", "\'",fee.toString(),"\' ");

  const accounts = await ethers.getSigners()

  // We get the contract to deploy
  const Rifa = await ethers.getContractFactory('Rifa')
  const rifa = await Rifa.deploy(vrfCoordinator, linkToken, keyHash, fee);

  await rifa.deployed()

  console.log('Rifa deployed to:', rifa.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
