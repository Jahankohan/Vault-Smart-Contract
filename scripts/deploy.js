// scripts/deploy.js
const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    const networkConfig = hre.network.config;
    const WETH_ADDRESS = networkConfig.wethAddress;
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());


    const Vault = await ethers.getContractFactory("Vault");
    const vault = await Vault.deploy(WETH_ADDRESS);
    await vault.deployed();
    console.log("Vault deployed to:", vault.address);

    // Write deployed addresses to a file
    const addresses = {
        WETH: WETH_ADDRESS,
        Vault: vault.address
    };
    fs.writeFileSync(path.join(__dirname, '../deployedAddresses.json'), JSON.stringify(addresses, undefined, 2));
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
