set -o allexport
source ./.env
source ./.env_public
set +o allexport

forge create \
      --private-key $PRIVATE_KEY_1  \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID  \
      src/Attack.sol:Attack
