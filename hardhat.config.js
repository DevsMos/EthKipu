require('@nomiclabs/hardhat-ethers');

module.exports = {
  solidity: "0.8.0",
  networks: {
    sepolia: {
      url: "https://eth-sepolia.alchemyapi.io/v2/YOUR_ALCHEMY_API_KEY", // Alchemy URL
      accounts: [`0x${YOUR_PRIVATE_KEY}`] // Sua chave privada
    }
  }
};
