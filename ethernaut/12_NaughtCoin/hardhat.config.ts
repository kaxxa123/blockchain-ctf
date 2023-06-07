import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config({path: "../.env"})

const {
    PROJECT_ID,
    PRIVATE_KEY_1,
    PRIVATE_KEY_2
} = process.env;

const config: HardhatUserConfig = {
    solidity: "0.8.18",

    networks: {
        hardhat: {
            //Goerli Fork
            forking: {
                url: `https://goerli.infura.io/v3/${PROJECT_ID}`,
                blockNumber: 9137400
            },
            chainId: 5,
            accounts: [{privateKey: `${PRIVATE_KEY_1}`, 
                        balance: "1000000000000000000000000000000"}],
        },

        goerli: {
            url: `https://goerli.infura.io/v3/${PROJECT_ID}`,
            chainId: 5,
            //Identical entries will be filtered!
            accounts: [`${PRIVATE_KEY_1}`, `${PRIVATE_KEY_2}`]
        },

    }
};

export default config;
