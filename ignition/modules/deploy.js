const hre = require("hardhat");

async function main() {

    const nftvar = await hre.ethers.getContractFactory("NFTMarketplace");
    const lock = await lock.deploy();

    await lock.deployed();

    console.log('lock with 1 eth');
}


main().catch((error)=> {
    console.error(error);
    process.exitCode= 1;
});