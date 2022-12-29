    
// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.0;

//the router wraps the actual token with its “anyToken”. 
//For example, the DAI token is wrapped as anyDAI, or conversely DAI is the underlying asset of anyDAI
contract contrivedbug{

    function anySwapOutUnderlyingWithPermit(
        address from,
        address token, //attacker's address, which is not even from AnySwap
        address to,
        uint amount,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint toChainID
    ) external {
        //unwraps the underlying token (“DAI”) from the its anyToken wrapping (“anyDAI”)
        //token now is now the attacker’s controlled contract. We can see in the debugger, 
        //that this contract now returns WETH as its “underlying asset”.
        // Multichain failed here as this function should have checked if the token address is indeed a Multichain token
        // !here bug; should've checked whether token is a valid anyswap address
        address _underlying = AnyswapV1ERC20(token).underlying();
        // The underlying token’s (“DAI”) ERC20 contract permit() is called to approve 
        //the router’s (this) ability to withdraw an amount from the user’s (from) address, 
        //as the user supplied a signed transaction for that, denoted by (v,r,s)


        //Originally, the expected result was that the underlying token’s (“WETH”) ERC20 contract permit() 
        //is called to approve the router’s (this) ability to withdraw an amount from the user’s (from) address,
        // as the user supplied a signed transaction for that denoted by (v,r,s). 
        //However, WETH contract does not have a permit() function!
        // WETH contract does have a “fallback function” that is called when a function is called but not found.
        // WETH’s fallback function is deposit() that does nothing material in this case, 
        //but allows its calling function’s execution to continue as it does not fail.
        IERC20(_underlying).permit(from, address(this), amount, deadline, v, r, s);
        //if we got to this line it means the signature in the line above was verified and 
        //now we can use the approve granted by it to the router, to actually move the the 
        //amount from the user to the wrapped token account.
        TransferHelper.safeTransferFrom(_underlying, from, token, amount);
        //The rest of the function deals with its wrapped version accounting and sending across chains.
        AnyswapV1ERC20(token).depositVault(amount, from);
        _anySwapOut(from, token, to, amount, toChainID);
    }
}