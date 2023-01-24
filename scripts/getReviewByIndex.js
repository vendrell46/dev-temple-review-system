const { getNamedAccounts, ethers } = require("hardhat")

async function main() {
    const { deployer } = await getNamedAccounts()
    const reviewMe = await ethers.getContract("ReviewMe", deployer)

    console.log("Retrieving review...")
    const transactionResponse = await reviewMe.getReviewByIndex(0)
    await transactionResponse.wait(1)
    console.log("Details of this revie retrieved...")
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
