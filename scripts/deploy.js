const hre = require("hardhat");

const tokens = (nToken) => {
  return hre.ethers.utils.parseUnits(nToken.toString(), "ether"); // Исправлено с parsedUtils
};

async function main() {
  const _initialSupply = tokens(1000000000);
  const Allodium = await hre.ethers.getContractFactory("Allodium");

  const allodium = await Allodium.deploy(_initialSupply);
  await allodium.deployed();
  console.log(`Allodium deployed to: ${allodium.address}`);

  // Token Sale contract
  const _tokenPrice = tokens(1);
  const TokenSale = await hre.ethers.getContractFactory("TokenSale");
  const tokenSale = await TokenSale.deploy(allodium.address, _tokenPrice);

  await tokenSale.deployed();
  console.log(`TokenSale deployed to: ${tokenSale.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
