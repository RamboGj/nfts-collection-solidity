const main = async () => {
    // compila
    const nftContractFactory = await hre.ethers.getContractFactory("MyNFTCollection")

    // da deploy
    const nftContract = await nftContractFactory.deploy()
    
    //aguarda o deploy para continuar
    await nftContract.deployed()

    console.log("Contrato implantado!", nftContract.address)

    let txn = await nftContract.makeAnNFT()
    await txn.wait()

    txn = await nftContract.makeAnNFT()
    await txn.wait()

}

const runMain = async () => {
    try {
        await main()
        process.exit(0)
    } catch (error) {
        console.log(error)
        process.exit(1)
    }
}

runMain()