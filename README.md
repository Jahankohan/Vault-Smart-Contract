# Vault Project

This project implements a smart contract named `Vault`, which is designed to manage deposits, withdrawals, and interactions with WETH (Wrapped Ether). It includes features such as depositing and withdrawing ETH and ERC20 tokens, as well as wrapping and unwrapping WETH.

## Features

- **ETH and ERC20 Management**: Users can deposit and withdraw both Ethereum (ETH) and any ERC20 tokens.
- **WETH Integration**: Allows for direct wrapping and unwrapping of ETH into WETH within the contract itself.
- **Security Measures**: Includes reentrancy guards and follows the check-effects-interactions pattern to ensure secure transactions.

## Technology Stack

- **Solidity**: Smart contract programming language
- **Hardhat**: Ethereum development environment for deployment, testing, and debugging
- **Ethers.js**: Ethereum wallet implementation and utilities for interacting with the Ethereum Blockchain

## Setup and Installation

Ensure you have [Node.js](https://nodejs.org/) and npm installed. Then, follow these steps to set up the project locally.

1. Clone the repository:
   
    ```bash
   git clone git@github.com:Jahankohan/Vault-Smart-Contract.git
   cd Vault-Smart-Contract

2. Install dependencies:
    
   ```bash
   npm install

3. Create a .env file in the root directory and update it with your Ethereum network settings and private keys:
    
   ```bash
    PRIVATE_KEY=your-private-key-here
    INFURA_API_KEY=your-infura-api-key
   

## Deploying the Contracts

To deploy the contracts to a network:

1. Run the deployment script:
    
   ```bash
    npx hardhat run scripts/deploy.js --network <network-name>

2. After deployment, contract addresses will be saved to deployedAddresses.json.

## Verifying Contracts

To verify the deployed contracts on Etherscan:
    
    ```bash
    npx hardhat run scripts/verify.js --network <network-name>

## Running Tests

Execute automated tests to ensure the contract operates as expected:

    ```bash
    npx hardhat test

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests with any updates. Make sure to run tests before proposing significant changes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
