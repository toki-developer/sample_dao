import { ethers } from "hardhat";

async function main() {
  const TkoToken = await ethers.getContractFactory("TkoToken");
  const token = await TkoToken.deploy(
    "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
  );
  await token.deployed();

  console.log(`TkoToken deployed to ${token.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
