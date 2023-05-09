const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('NFT'); //Complies the contract. 
    const nftContract = await nftContractFactory.deploy(); //Deploys the contract to our local blockchain
    await nftContract.deployed(); //wait until the contract as been deployed. 
    console.log("Contract deployed to: ", nftContract.address);

    // Call the function.
    let txn = await nftContract.makeNFT()
    // Wait for it to be mined.
    await txn.wait()

    // Mint another NFT for fun.
    txn = await nftContract.makeNFT()
    // Wait for it to be mined.
    await txn.wait()

};



const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain(); 
