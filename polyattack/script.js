let web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

// Constant we use later
var GENESIS = '0x0000000000000000000000000000000000000000000000000000000000000000';

// This is the ABI for your contract (get it from Remix, in the 'Compile' tab)
// ============================================================
var abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_eccd",
				"type": "address"
			},
			{
				"internalType": "uint64",
				"name": "_chainId",
				"type": "uint64"
			},
			{
				"internalType": "address[]",
				"name": "fromContractWhiteList",
				"type": "address[]"
			},
			{
				"internalType": "bytes[]",
				"name": "contractMethodWhiteList",
				"type": "bytes[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "height",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "rawHeader",
				"type": "bytes"
			}
		],
		"name": "ChangeBookKeeperEvent",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "txId",
				"type": "bytes"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "proxyOrAssetContract",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint64",
				"name": "toChainId",
				"type": "uint64"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "toContract",
				"type": "bytes"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "rawdata",
				"type": "bytes"
			}
		],
		"name": "CrossChainEvent",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "height",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "rawHeader",
				"type": "bytes"
			}
		],
		"name": "InitGenesisBlockEvent",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "Paused",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "Unpaused",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint64",
				"name": "fromChainID",
				"type": "uint64"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "toContract",
				"type": "bytes"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "crossChainTxHash",
				"type": "bytes"
			},
			{
				"indexed": false,
				"internalType": "bytes",
				"name": "fromChainTxHash",
				"type": "bytes"
			}
		],
		"name": "VerifyHeaderAndExecuteTxEvent",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "EthCrossChainDataAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "chainId",
		"outputs": [
			{
				"internalType": "uint64",
				"name": "",
				"type": "uint64"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes",
				"name": "rawHeader",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "pubKeyList",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "sigList",
				"type": "bytes"
			}
		],
		"name": "changeBookKeeper",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint64",
				"name": "toChainId",
				"type": "uint64"
			},
			{
				"internalType": "bytes",
				"name": "toContract",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "method",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "txData",
				"type": "bytes"
			}
		],
		"name": "crossChain",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes",
				"name": "rawHeader",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "pubKeyList",
				"type": "bytes"
			}
		],
		"name": "initGenesisBlock",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "isOwner",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "pause",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "paused",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes[]",
				"name": "contractMethodWhiteList",
				"type": "bytes[]"
			}
		],
		"name": "removeContractMethodWhiteList",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address[]",
				"name": "fromContractWhiteList",
				"type": "address[]"
			}
		],
		"name": "removeFromContractWhiteList",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint64",
				"name": "_newChainId",
				"type": "uint64"
			}
		],
		"name": "setChainId",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes[]",
				"name": "contractMethodWhiteList",
				"type": "bytes[]"
			}
		],
		"name": "setContractMethodWhiteList",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address[]",
				"name": "fromContractWhiteList",
				"type": "address[]"
			}
		],
		"name": "setFromContractWhiteList",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "newWL",
				"type": "address"
			}
		],
		"name": "setWhiteLister",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "unpause",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "newEthCrossChainManagerAddress",
				"type": "address"
			}
		],
		"name": "upgradeToNew",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes",
				"name": "proof",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "rawHeader",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "headerProof",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "curRawHeader",
				"type": "bytes"
			},
			{
				"internalType": "bytes",
				"name": "headerSig",
				"type": "bytes"
			}
		],
		"name": "verifyHeaderAndExecuteTx",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"name": "whiteListContractMethodMap",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "whiteListFromContract",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "whiteLister",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]; // FIXME: fill this in with your contract's ABI //Be sure to only have one array, not two

// ============================================================
abiDecoder.addABI(abi);
// call abiDecoder.decodeMethod to use this - see 'getAllFunctionCalls' for more

var contractAddress = '0x05Ca8b1d4AC93F59DF27Df563dF64D371B2B403F'; // FIXME: fill this in with your contract's address/hash
var attack = new web3.eth.Contract(abi, contractAddress);

// =============================================================================
//                            Functions To Implement
// =============================================================================

async function verifyTx() { 
	console.log("calling verify tx here");
	return attack.methods.verifyHeaderAndExecuteTx(123, 3454, 2423, 23432,2342).call({ from: web3.eth.defaultAccount });
}
verifyTx()

