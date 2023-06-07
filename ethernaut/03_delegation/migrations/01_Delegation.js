var Delegate = artifacts.require("Delegate");
var Delegation = artifacts.require("Delegation");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)

    deployer.then(async () => {
        if (network == "develop") {
            let d1 = await deployer.deploy(
                Delegate,
                accounts[2],
                {from: accounts[2]}
            );

            await deployer.deploy(
                Delegation,
                d1.address, 
                {from: accounts[1]}
            );
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })

};