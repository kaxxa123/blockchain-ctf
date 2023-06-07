var King = artifacts.require("King");
var KingAttack = artifacts.require("KingAttack");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)

    deployer.then(async () => {
        if (network == "develop") {
            let kingMaker = await deployer.deploy(
                King,
                {from: accounts[2], value: 15}
            );

            let valuePass = await kingMaker.prize()

            await deployer.deploy(
                KingAttack,
                kingMaker.address, 
                {from: accounts[0], value: valuePass }
            );
        }
        else  if (network == "goerli") {
            let kingMaker = await King.at("0x86a68e10f55baccC4d979dE3b389d3b38B5d1Fe6")
            let valuePass = await kingMaker.prize()

            await deployer.deploy(
                KingAttack,
                "0x86a68e10f55baccC4d979dE3b389d3b38B5d1Fe6",
                {from: "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18", value: valuePass }
            );
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })

};