
pragma solidity 0.5.17;

import "@openzeppelin/contracts/token/ERC721/ERC721Metadata.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract contrived{
    function init(
        address newOwner,
        string calldata tokenName,
        string calldata tokenSymbol
    ) external {
        _transferOwnership(newOwner);
        _tokenName = tokenName;
        _tokenSymbol = tokenSymbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);

        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }
}