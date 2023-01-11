/**
 *Submitted for verification at Etherscan.io on 2022-07-19
*/

// Sources flattened with hardhat v2.9.1 https://hardhat.org

// File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.0


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

contract contrived{

 // Sell NFTs (Buy Jay)
    function buyJay(
        address[] calldata erc721TokenAddress,//attacker defined 
        uint256[] calldata erc721Ids,
        address[] calldata erc1155TokenAddress,
        uint256[] calldata erc1155Ids,
        uint256[] calldata erc1155Amounts
    ) public payable {
        require(start, "Not started!");
        //attacker can define erc721TokenAddress
        uint256 total = erc721TokenAddress.length;
        if (total != 0) buyJayWithERC721(erc721TokenAddress, erc721Ids);

        if (erc1155TokenAddress.length != 0)
            total = total.add(
                buyJayWithERC1155(
                    erc1155TokenAddress,
                    erc1155Ids,
                    erc1155Amounts
                )
            );

        if (total >= 100)
            require(
                msg.value >= (total).mul(sellNftFeeEth).div(2),
                "You need to pay ETH more"
            );
        else
            require(
                msg.value >= (total).mul(sellNftFeeEth),
                "You need to pay ETH more"
            );

        _mint(msg.sender, ETHtoJAY(msg.value).mul(97).div(100));

        (bool success, ) = dev.call{value: msg.value.div(34)}("");
        require(success, "ETH Transfer failed.");

        nftsSold += total;

        emit Price(block.timestamp, JAYtoETH(1 * 10**18));
    }

        //buggy function: price = totalSupply/ETH

        function ETHtoJAY(uint256 value) public view returns (uint256) {
         return value.mul(totalSupply()).div(address(this).balance.sub(value));
        }

//this function is used for sell()
//During the transfer, the attacker executed and reentered the JAY contract by invoking the sell 
//function on the fake ERC-721 token and sold all JAY tokens.
// The JAY token price got manipulated since the Ether balance was raised before the buyJay function was initiated
        function JAYtoETH(uint256 value) public view returns (uint256) {
                return (value * address(this).balance).div(totalSupply());
                }


}