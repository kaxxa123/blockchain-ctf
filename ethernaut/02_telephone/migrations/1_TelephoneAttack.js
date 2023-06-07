var TelephoneAttack = artifacts.require("TelephoneAttack");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)

    deployer.then(async () => {
        if (network == "goerli") {
            await deployer.deploy(
                TelephoneAttack,
                "0x345E615311dee8FF11889FF57ED615Db3905f776",
                {from: "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18"}
            );
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })

};