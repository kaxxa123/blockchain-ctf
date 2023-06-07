var CoinFlip = artifacts.require("CoinFlip");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)
    deployer.then(async () => {
        // deployment steps
        if (network == "develop") {
            await deployer.deploy(CoinFlip, {from: accounts[1]});
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })
};