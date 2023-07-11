set -o allexport
source ./.env
source ./.env_public
set +o allexport

forge create \
      --private-key $PRIVATE_KEY_1  \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID  \
      src/AttackContract.sol:AttackContract

# Deployer: 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
# Deployed to: 0xCB95ed4ec2bbaA9B6e8bE43b6c2bC7665896748e
# Transaction hash: 0xde7cac14d9e9079d94d9a83f73094a07754c4618acab92a9a0325779c97be2fa