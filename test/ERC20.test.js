const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Vault ERC20 Transactions', function () {
    let vault, token, owner;

    beforeEach(async function () {
        [owner] = await ethers.getSigners();

        const MockERC20 = await ethers.getContractFactory("MockERC20");
        token = await MockERC20.deploy("Mock Token", "MTK", ethers.utils.parseEther("1000"));
        await token.deployed();
        console.log("Token deployed to:", token.address);
        
        // Deploying the mock WETH contract first
        const WETH = await ethers.getContractFactory("MockWETH");
        weth = await WETH.deploy();
        await weth.deployed();
        console.log("Weth Deployed successfully:", weth.address)
        
        // Now deploy Vault with the WETH contract address
        const Vault = await ethers.getContractFactory("contracts/Vault.sol:Vault");
        vault = await Vault.deploy(weth.address);
        await vault.deployed();
        console.log("Vault Deployed Successfully:", vault.address)
    });

    it('should deposit and withdraw ERC20 tokens correctly', async function () {
        const depositAmount = ethers.utils.parseEther("100");
        const withdrawAmount = ethers.utils.parseEther("50");

        // Owner approves Vault to handle the deposit amount of 
        try {
            await token.connect(owner).approve(vault.address, depositAmount, {gasLimit: 100000});
            console.log("Tokens approved.");
        } catch (error) {
            console.error("Approval failed:", error);
        }

        // Deposit ERC20 tokens into the vault
        await vault.connect(owner).depositERC20(token.address, depositAmount);

        const realBalance = await vault.getERC20Balance(token.address)
        // Check balance after deposit
        expect(realBalance.toString()).to.equal(depositAmount.toString());
       
        // Withdraw some of the ERC20 tokens from the vault
        await vault.connect(owner).withdrawERC20(token.address, withdrawAmount);

        const newRealBalance = await vault.getERC20Balance(token.address)
        // Check balance after withdrawal
        expect(newRealBalance.toString()).to.equal(depositAmount.sub(withdrawAmount).toString());
    });
});
