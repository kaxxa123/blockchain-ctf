var Privacy = artifacts.require("Privacy");

module.exports = function(deployer, network, accounts) {
    console.log(`Deployment on: ${network}`)
    deployer.then(async () => {
        // deployment steps
        if (network == "develop") {
            await deployer.deploy(
                            Privacy, [
                                "0x1234567890123456789012345678901234567890123456789012345678901234",
                                "0x2222222222222222222222222222222222222222222222222222222222222222",
                                "0x5678222334455667788995678222334455667788995678222334455667788991"], 
                            {from: accounts[1]});
        }
        else {
            console.log(`Deployment on ${network} not supported`)
        }
    })
};