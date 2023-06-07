import { artifacts, ethers } from "hardhat"

async function getBytecode(contractName: string): Promise<string> {
    const ctrArtifact = await artifacts.readArtifact(contractName);
    return ctrArtifact.bytecode;
}

async function calcAddress(
        contractName: string,
        creator: string, 
        salt: string): Promise<string> {
  
    const bytecode = await getBytecode(contractName);
    const hash = ethers.utils.keccak256(bytecode)
  
    // Compute the contract address
    return ethers.utils.getCreate2Address(creator, salt, hash);
}

// Usage example
async function main() {
    const creator  = "0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18";
    const contractName = "Attack";

    // 64-bytes of salt
    const salt     = "0x1234567890123456789012345678901234567890123456789012345678901234"; 

    const addr = await calcAddress(contractName, creator, salt);
    console.log("Contract address: ", addr);
}

main();
