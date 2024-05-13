require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      wethAddress: process.env.SEPOLIA_WETH_ADDRESS
    },
    holesky: {
      url: process.env.HOLESKY_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      wethAddress: process.env.HOLESKY_WETH_ADDRESS
    }
  },
  etherscan: {
      apiKey: process.env.ETHERSCAN_API_KEY
  }
};
