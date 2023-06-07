var CoinFlip = artifacts.require("CoinFlip");
var CoinFlipAttack = artifacts.require("CoinFlipAttack");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)

    deployer.then(async () => {
        if (network == "develop") {
            let flip = await CoinFlip.deployed();
            await deployer.deploy(
                CoinFlipAttack,
                flip.address, 
                {from: accounts[1]}
            );
        }
        else  if (network == "goerli") {
            await deployer.deploy(
                CoinFlipAttack,
                "0xA737b256ed909Fd726Ef5E59793fd9A60D516D23",
                {from: "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18"}
            );
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })

};