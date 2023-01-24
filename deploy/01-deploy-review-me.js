const { network } = require("hardhat")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const reviewMe = await deploy("ReviewMe", {
        from: deployer,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    // Verify Smart Contract
    if (process.env.ETHERSCAN_API_KEY) {
        await verify(reviewMe.address)
    }
    log("-----------------------------------------------")
}

module.exports.tags = ["ReviewMe"]
