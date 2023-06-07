var Elevator = artifacts.require("Elevator");
var Attack = artifacts.require("Attack");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)
    deployer.then(async () => {
        // deployment steps
        if (network == "develop") {
            let lift = await deployer.deploy(
                            Elevator, 
                            {from: accounts[1]});

            await deployer.deploy(
                            Attack, 
                            lift.address,  
                            {from: accounts[1]});
        }
        else  if (network == "goerli") {
            await deployer.deploy(
                            Attack,
                            "0xaef17A18bd4ec8abCE38EeE6B054242a69482D11",
                            {from: "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18"});
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })
};