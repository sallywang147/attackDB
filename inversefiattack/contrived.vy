#The Inverse price oracle estimated the value of its LP token price based on the balance of 
#current assets within the pool.  
#Since the attacker can manipulate this balance of assets through deposits, swaps, and trades, 
#they can manipulate the value of the LP token.
def get_virtual_price() -> uint256:
    """
    @notice The current virtual price of the pool LP token
    @dev Useful for calculating profits
    @return LP token virtual price normalized to 1e18
    """
    amp: uint256 = self._A()
    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]
    xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)
    D: uint256 = self.get_D(xp, amp)
    # D is in the units similar to DAI (e.g. converted to precision 1e18)
    # When balanced, D = n * x_u - total virtual value of the portfolio
    return D * PRECISION / self.totalSupply