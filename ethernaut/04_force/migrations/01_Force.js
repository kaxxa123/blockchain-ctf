var Force = artifacts.require("Force");
var Feed = artifacts.require("Feed");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)

    deployer.then(async () => {
        if (network == "develop") {
            let forceCtr = await deployer.deploy(
                Force,
                {from: accounts[2]}
            );

            await deployer.deploy(
                Feed,
                forceCtr.address, 
                {from: accounts[0], value: 1 }
            );
        }
        else  if (network == "goerli") {
            await deployer.deploy(
                Feed,
                "0x115C15DFaB81881E6D19e9C52955C711634dDb9c",
                {from: "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18", value: 1 }
            );
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })

};