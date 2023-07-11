set -o allexport
source ./.env
source ./.env_public
set +o allexport

echo 
echo "Setting Alert in Forta..."
cast send $FORTA \
    "setDetectionBot(address)" \
    $MYALERT \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

echo "Try to take legacy tokens out..."
cast send $CVAULT \
    "sweepToken(address)" \
    $DET_DELEGATEFROM \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

