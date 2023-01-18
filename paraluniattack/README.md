**[Paraluni Attack](https://www.certik.com/resources/blog/4mPLWLwyKG4xy30x65uLgw-paraluni-exploit)**

[more analysis](https://blocksecteam.medium.com/not-all-tokens-are-good-the-quick-analysis-of-the-paraluni-attack-fabef25f714c)

[more analysis2](https://mirror.xyz/0xaB265E6124dedE46C85336e720521209d51E403e/PyQM3Ooyj45g4h06wkmCpgQfk7eEg_R00mCcXvIzyNg)

The bug is in the masterchef contract and the aattacak logic is below

```
  masterchef.depositByAddLiquidity(tokenA, tokenB)
  
         paraRouter.addLiquidity(tokenA, tokenB)

             paraRouter.safeTransferFrom(tokenA, masterchef, pair, amount)

                tokenA.transferFrom(masterchef, pair, amount)

                     masterchef.depositByAddLiquidity(usdt, busd)

                        paraRouter.addLiquidity(usdt, busd)

                             paraRouter.safeTransferFrom(usdt, masterchef, pair, amount)

                                 usdt.transferFrom(masterchef, pair, amount)

                             pair.mint(lp) = amountA

                         var.newBalance = amountA

                     masterChef._deposit(_pid,amountA,_user)

                pair.mint(lp) = amountB  => useless!!!

             var.newBalance = amountA!!!

        masterchef._deposit(_pid,amountA,_user)
 ```
