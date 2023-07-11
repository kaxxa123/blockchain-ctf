# Good Samaritan

[Good Samaritan](https://ethernaut.openzeppelin.com/level/0x8586Fe7809208B08691A1D225ab2648De02de76B)

_drain all the balance from his Wallet_

1. `GoodSamaritan` gives away 10 tokens for free when `requestDonation` is invoked...
1. ...unless its call to `donate10()` fails with `NotEnoughBalance()`...
1. ...in which case it hands over the entire balance.
1. We can raise this error at the `notify` call within the receiving contract.


<BR />

## Attack Test

```DASH
forge test -vvvv
```


<BR />

## Live Attack

```BASH
./attackDeploy.sh
./attackDo.sh
```

<BR />
