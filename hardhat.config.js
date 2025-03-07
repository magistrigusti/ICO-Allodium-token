require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
    solidity: "0.8.20",
    networks: {
        hardhat: {},
        sepolia: {
            url: `https://eth-sepolia.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
};