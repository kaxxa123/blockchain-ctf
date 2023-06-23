set -o allexport
source ./.env
source ./.env_public
set +o allexport

# ===================================
echo "TOKEN1 totalSupply:"
cast call $TOKEN1 \
    "totalSupply()(uint256)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "TOKEN2 totalSupply:"
cast call $TOKEN2 \
    "totalSupply()(uint256)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

# ===================================
echo "DEX Token1:"
cast call $TOKEN1 \
    "balanceOf(address)(uint256)" \
    $DEX \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "DEX Token2:"
cast call $TOKEN2 \
    "balanceOf(address)(uint256)" \
    $DEX \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

# ===================================
echo "PLAYER Token1:"
cast call $TOKEN1 \
    "balanceOf(address)(uint256)" \
    $PLAYER \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "PLAYER Token2:"
cast call $TOKEN2 \
    "balanceOf(address)(uint256)" \
    $PLAYER \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

# ===================================
cast send $FAKE \
    "transfer(address,uint256)" \
    $DEX  1 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $FAKE \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  3 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $FAKE  $TOKEN1  1 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $FAKE  $TOKEN2  2 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo

# ===================================
echo "PLAYER Token1:"
cast call $TOKEN1 \
    "balanceOf(address)(uint256)" \
    $PLAYER \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "PLAYER Token2:"
cast call $TOKEN2 \
    "balanceOf(address)(uint256)" \
    $PLAYER \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo
