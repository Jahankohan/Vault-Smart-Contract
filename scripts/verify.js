// scripts/verify.js
const fs = require('fs');
const path = require('path');

async function main() {
    // Load deployed addresses from file
    const deployedAddresses = JSON.parse(fs.readFileSync(path.join(__dirname, '../deployedAddresses.json'), 'utf8'));

    console.log("Verifying Vault contract at address:", deployedAddresses.Vault);
    await hre.run("verify:verify", {
        address: deployedAddresses.Vault,
        constructorArguments: [
            deployedAddresses.WETH
        ],
    });
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
