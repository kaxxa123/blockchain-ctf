var Reentrance = artifacts.require("Reentrance");
var Attack = artifacts.require("Attack");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)
    deployer.then(async () => {
        // deployment steps
        if (network == "develop") {
            let r1 = await deployer.deploy(
                            Reentrance, 
                            {from: accounts[1]});

            await deployer.deploy(
                            Attack, 
                            r1.address,  
                            {from: accounts[1]});
        }
        else  if (network == "goerli") {
            await deployer.deploy(
                            Attack,
                            "0x9C26748d6e0803A3094da1805b1579B7831E628C",
                            {from: "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18"});
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })
};