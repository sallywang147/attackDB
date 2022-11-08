pragma solidity ^0.5.0;

import "./../../../libs/math/SafeMath.sol";
import "./../../../libs/common/ZeroCopySource.sol";
import "./../../../libs/common/ZeroCopySink.sol";
import "./../../../libs/utils/Utils.sol";
import "./../upgrade/UpgradableECCM.sol";
import "./../libs/EthCrossChainUtils.sol";
import "./../interface/IEthCrossChainManager.sol";
import "./../interface/IEthCrossChainData.sol";
contract contrived {

        function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) external returns (bool) {
                // Load Ethereum cross chain data contract
                IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
                
                // To help differentiate two txs, the ethTxHashIndex is increasing automatically
                uint256 txHashIndex = eccd.getEthTxHashIndex();
                
                // Convert the uint256 into bytes
                bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
                
                // this is where bug happened: the clever hacker figured a hash to invoke
                //the ethCrossChainData contract method 
                bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
                    ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
                    ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
                    ZeroCopySink.WriteUint64(toChainId),
                    ZeroCopySink.WriteVarBytes(toContract),
                    ZeroCopySink.WriteVarBytes(method),//bugggy source line 
                    ZeroCopySink.WriteVarBytes(txData)
                );

        }
}

        