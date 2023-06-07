# OpenZeppelin Ethernaut CTF

* [OpenZeppelin Ethernaut](https://ethernaut.openzeppelin.com/)

* [Github Collection of CTFs](https://github.com/blockthreat/blocksec-ctfs.git)

* [Ethernaut Solutions](https://blog.dixitaditya.com/series/ethernaut)


<BR />


## Truffle Project Setup Quick Ref

```BASH
mkdir prject
cd    project
npm init -y
npm i @truffle/hdwallet-provider
npm i dotenv
truffle init
```

Copy file:

```BASH
cp ./truffle-config.js ./project/
```

<BR />


## Hardhat Project Setup Quick Ref

```BASH
mkdir project
cd    project
npm init -y
npm i --save-dev hardhat
npx hardhat
npm i --save-dev @nomicfoundation/hardhat-toolbox
npm i --save-dev typescript
npm i --save-dev ts-node
npm i --save-dev @types/node
npm i dotenv
```

Copy Files:

```BASH
cp ./environment.d.ts  ./project/scripts/
cp ./hardhat.config.ts ./project/
```

Once the challenge is deployed update block number value for forking goerli at ``hardhat.config.ts``


<BR />
