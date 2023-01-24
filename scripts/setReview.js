const { getNamedAccounts, ethers } = require("hardhat")

async function main() {
    const { deployer } = await getNamedAccounts()
    const reviewMe = await ethers.getContract("ReviewMe", deployer)

    console.log("Setting up review...")
    transactionResponse = await reviewMe.setReview(
        "Now I am trying to review it from VSCode",
        5
    )
    await transactionResponse.wait(1)
    console.log("Review submitted!")
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
