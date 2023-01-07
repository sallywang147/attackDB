**[CreamFinance Attack](https://medium.com/immunefi/hack-analysis-cream-finance-oct-2021-fc222d913fc5)**

This analyis is a snapshot of the linked articles. 

1. Flash mint $500m DAI from MakerDAO
2. Deposit DAI into Yearn 4-Curve pool
3. Deposit Yearn 4-Curve into Yearn yUSD vault
4. Deposit yUSD into Cream yUSD market
5. Borrow Over 500,000 Ether from AAVE v2
6. Deposit Ether from another smart contract into Cream eth market — Account 2
7. Borrow yUSD from Account 2 and deposit into Account 1 as collateral twice
8. Borrow yUSD from Account 2 and send to Account 1
9. Withdraw Yearn 4-Curve from yUSD vault
10. Send $10m Yearn 4-Curve to yUSD vault
11. Borrow all available liquidity using Account 1
12. Swap stolen funds for DAI and WETH
13. Withdraw DAI from Yearn 4-Curve
14. Repay AAVE Eth flash loan
15. Repay DAI flashmint
16. Escape with profits

The majority of the damage can be narrowed down to two key reasons:

(I) An easily manipulatable hybrid oracle, which is manipulated at step 10
(II) Uncapped supplying of a token, which is manipulated in steps 7 and 8

Cream Finance developers fixed the loophole by 1) setting a token collateral cap; 2)forbid the use of wrapped tokens such as LPtoken; 
