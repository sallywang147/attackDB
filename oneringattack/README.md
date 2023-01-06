**[OneRing Finance Attack](https://inf.news/en/tech/0d2cb66f3336a97eea15380b3cae806c.html)**

1. the attacker first invokes the `depositSafe()` function, which will invoke the underlying `deposit()` function;
2. `deposit()` function invokes `doHardWork()` function, which mints OShare to the attacker;
3.  the OShare price calculated by `getSharePrice()` function live in a single pool; 
4.  `getSharePrice()` function then invokes `investedBalanceInUSD()` function and `balanceWithInvested()` function. The invocation is below: 
 <img width="677" alt="Screen Shot 2023-01-04 at 4 24 10 PM" src="https://user-images.githubusercontent.com/60257613/210652616-f73ba599-5cd2-4161-92e3-516750bf0aa3.png">
5.  the contract uses two tokens' reserve for calculation, and the previous attacker deposited a large amount of USDC due to the flash loan, which made the final _amount value also increased . Going back to the getSharePrice function again, you can find that _sharePrice will also increase accordingly.
<img width="683" alt="Screen Shot 2023-01-04 at 4 27 50 PM" src="https://user-images.githubusercontent.com/60257613/210653765-a38948a5-ea1d-4992-b89f-eedcc0261ddb.png">
6. Since the attacker deposited USDC from flashloan, the  `_amount` in reserve increased;
7. Then the attacker calls  `withdraw() ` functinon, which invokes  `getSharePrice() ` function

<img width="678" alt="Screen Shot 2023-01-04 at 4 35 09 PM" src="https://user-images.githubusercontent.com/60257613/210654313-ae958240-a59c-4b2f-8f52-e420ee384e6f.png">
8. `getSharePrice()` was also called to calculate the OShare price. At this stage, it was 1136563707735425848. The OShare price did increase due to previous deposit of USDC
9. Then the `_withdraw()` function calls `_realWithdraw()`, which computes the final balance with `balanceWithInvested`, so this will eventually lead to more OShares converted to USDC.

The root cause: the contract computes price of tokens by real-time change in the liquidity pool. As a result, the attacker can manipulate the 
price oracle by flash loaning a large amount of USDC  and depositing the USDC. This way, the attacker increases the price of OShare, resulting in the difference and profit.
