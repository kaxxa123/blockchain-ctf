set -o allexport
source ./.env
source ./.env_public
set +o allexport

forge create \
      --private-key $PRIVATE_KEY_1  \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID  \
      src/AttackContract.sol:AttackContract

# Deployer: 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
# Deployed to: 0x5FeF027eE7B19D535976DbBEE263a2d367fE0450
# Transaction hash: 0xc02e5538d0e73b9f93478f88a891d8d414c862b942a03c5aa2306f79b74eaaa6