const { ethers } = require('hardhat');
const assert = require('assert');

describe('Vault', function () {
    let vault;
    let weth;
    let owner;

    beforeEach(async function () {
        [owner] = await ethers.getSigners();
        
        // Deploying the mock WETH contract first
        const WETH = await ethers.getContractFactory("contracts/Mock/MockWETH.sol:MockWETH");
        weth = await WETH.deploy();
        await weth.deployed();
        console.log("Weth Deployed successfully:", weth.address)
        // Now deploy Vault with the WETH contract address
        const Vault = await ethers.getContractFactory("contracts/Vault.sol:Vault");
        vault = await Vault.deploy(weth.address);
        await vault.deployed();
        console.log("Vault Deployed Successfully:", vault.address)
    });

    it('should deposit ETH and update balances', async function () {
        const [owner] = await ethers.getSigners();
        const depositAmount = ethers.utils.parseEther("1.0");

        // Perform the deposit transaction
        const tx = await vault.connect(owner).depositETH({ value: depositAmount });
        await tx.wait();

        // Check the balance after the deposit
        const balance = await vault.getETHBalance();
        assert.strictEqual(balance.toString(), depositAmount.toString(), "Balance after deposit is incorrect.");
    });

    it('should deposit ETH and withdraw ETH correctly', async function() {
        const depositAmount = ethers.utils.parseEther("1.0");
        const withdrawAmount = ethers.utils.parseEther("0.5");

        // Deposit ETH
        await vault.connect(owner).depositETH({ value: depositAmount });
        await new Promise(resolve => setTimeout(resolve, 5000));

        let balance = await vault.getETHBalance();
        assert.strictEqual(balance.toString(), depositAmount.toString(), "Balance after deposit is incorrect.");

        // Withdraw ETH
        await vault.connect(owner).withdrawETH(withdrawAmount);
        await new Promise(resolve => setTimeout(resolve, 5000));

        balance = await vault.getETHBalance();
        assert.strictEqual(balance.toString(), ethers.utils.parseEther("0.5").toString(), "Balance after withdrawal is incorrect.");
    });

    it('should deposit ETH and wrap it to WETH', async function() {
        const depositAmount = ethers.utils.parseEther("1.0");

        // Deposit ETH
        await vault.connect(owner).depositETH({ value: depositAmount });
        await new Promise(resolve => setTimeout(resolve, 1000));

        // Wrap the deposited ETH to WETH
        await vault.connect(owner).wrapETH(depositAmount);
        await new Promise(resolve => setTimeout(resolve, 1000));

        
        // Check the WETH balance after wrapping
        const wethBalance = await vault.getERC20Balance(weth.address);
        assert.strictEqual(wethBalance.toString(), depositAmount.toString(), "WETH balance after wrapping is incorrect.");

        const postWrapETHBalance = await vault.getETHBalance();
        assert.strictEqual(postWrapETHBalance.toString(), "0", "ETH balance should be zero after wrapping.");
    });

});
