set -o allexport
source ./.env
source ./.env_public
set +o allexport

forge create \
      --private-key $PRIVATE_KEY_1  \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID  \
      src/AttackContract.sol:AttackContract

# Deployer: 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
# Deployed to: 0xF49bb930AB1B6620Ccc4C594E0103D2AF34743e3
# Transaction hash: 0xfc15ac73997817e28e619d72b6afd38044cd4f8aabc9dbf146f0687c80b31b3e