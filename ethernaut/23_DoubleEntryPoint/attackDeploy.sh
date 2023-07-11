set -o allexport
source ./.env
source ./.env_public
set +o allexport

forge create \
      --constructor-args  $CVAULT $FORTA \
      --private-key $PRIVATE_KEY_1  \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID  \
      src/MyAlert.sol:MyAlert

# Deployer: 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
# Deployed to: 0x3534a17Eea52dc0DC422E596DD6aA86adE78c69f
# Transaction hash: 0x8aba4aa5428963dd64988602a6435b397f80000395ec1159089494a308748a03