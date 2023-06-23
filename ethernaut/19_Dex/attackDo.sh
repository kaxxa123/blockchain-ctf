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
echo "Swapping Token1->Token2:  10"
cast send $TOKEN1 \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  10 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $TOKEN1  $TOKEN2  10 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo

# ===================================
echo "Swapping Token2->Token1:  20"
cast send $TOKEN2 \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  20 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $TOKEN2  $TOKEN1  20 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo


# ===================================
echo "Swapping Token1->Token2:  24"
cast send $TOKEN1 \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  24 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $TOKEN1  $TOKEN2  24 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo


# ===================================
echo "Swapping Token2->Token1:  30"
cast send $TOKEN2 \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  30 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $TOKEN2  $TOKEN1  30 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo


# ===================================
echo "Swapping Token1->Token2:  41"
cast send $TOKEN1 \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  41 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $TOKEN1  $TOKEN2  41 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo

# ===================================
echo "Swapping Token2->Token1:  45"
cast send $TOKEN2 \
    "approve(address,address,uint256)" \
    $PLAYER  $DEX  45 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $DEX \
    "swap(address,address,uint256)" \
    $TOKEN2  $TOKEN1  45 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo

