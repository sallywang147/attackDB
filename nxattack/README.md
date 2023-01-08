**[NXUSD Attack](https://medium.com/nereus-protocol/post-mortem-flash-loan-exploit-in-single-nxusd-market-343fa32f0c6)**

The root cause is in real-time calcuation of price based on token reserves without taking into consideration of block timestamp manipulation;
Specifically, NXUSD uses the following function:

LP price = (wavaxReserve * avaxPrice + usdcReserve * usdcPrice) / totalSupply

As you can see wavaxReserve, usdcReserve, and totalSupply were susceptible to price manipulation due to lack of TWAP(time weighted average price) calculation.

The fix is to add TWAP calculation.

**Deploy Link**
`make deploy-testnet contract_header=JLPWAVAXUSDCOracle absolute_path=[path to where you save the contract]`
<img width="1196" alt="Screen Shot 2023-01-08 at 6 01 50 PM" src="https://user-images.githubusercontent.com/60257613/211223421-f9ede87d-3611-4e6a-b5d7-c7aa9ff9d218.png">
