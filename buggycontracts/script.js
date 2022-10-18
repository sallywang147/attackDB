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
				"name": "_creditor",
				"type": "address"
			},
			{
				"internalType": "int32",
				"name": "_amount",
				"type": "int32"
			}
		],
		"name": "add_IOU",
		"outputs": [
			{
				"internalType": "int32",
				"name": "ret",
				"type": "int32"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "Received",
		"type": "event"
	},
	{
		"stateMutability": "nonpayable",
		"type": "fallback"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	},
	{
		"inputs": [],
		"name": "findRecord",
		"outputs": [
			{
				"components": [
					{
						"components": [
							{
								"internalType": "address",
								"name": "creditor",
								"type": "address"
							},
							{
								"internalType": "int32",
								"name": "amount",
								"type": "int32"
							},
							{
								"internalType": "uint256",
								"name": "creditor_id",
								"type": "uint256"
							},
							{
								"internalType": "bool",
								"name": "ack",
								"type": "bool"
							}
						],
						"internalType": "struct mycontract.IOU[]",
						"name": "IOU_List",
						"type": "tuple[]"
					},
					{
						"internalType": "address",
						"name": "debtor",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "ack",
						"type": "bool"
					}
				],
				"internalType": "struct mycontract.Debtor[]",
				"name": "input",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "debtor",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "creditor",
				"type": "address"
			}
		],
		"name": "lookup",
		"outputs": [
			{
				"internalType": "int32",
				"name": "ret",
				"type": "int32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]; // FIXME: fill this in with your contract's ABI //Be sure to only have one array, not two

// ============================================================
abiDecoder.addABI(abi);
// call abiDecoder.decodeMethod to use this - see 'getAllFunctionCalls' for more

var contractAddress = '0x787005F87c19681f218309110d88a68ec9B8fAA3'; // FIXME: fill this in with your contract's address/hash
var BlockchainSplitwise = new web3.eth.Contract(abi, contractAddress);

// =============================================================================
//                            Functions To Implement
// =============================================================================

// Helper functions
// *Done* TODO: Add any helper functions here! 
async function findRecord() { // https://stackoverflow.com/questions/71367683/how-to-get-transaction-receipt-event-logs
	return BlockchainSplitwise.methods.findRecord().call({ from: web3.eth.defaultAccount });
}

async function getNeighbors(node) { // get neighbor of a node (addr, amount) in debtor-creditor(IOU) map
	let retLedger = await findRecord();
	var idx = 0;
	var isDebtor = false;
	var neighbors = [];
	for (var i = 0; i < retLedger.length; i++) { // find for which node we're finding its neighbors
		if (retLedger[i]["debtor"].toLowerCase() == node.toLowerCase()) {
			idx = i;
			isDebtor = true;
			break;
		}
	}
	if (isDebtor) {
		for (var j = 0; j < retLedger[idx]["IOU_List"].length; j++) {
			if (retLedger[idx]["IOU_List"][j]["ack"])
				neighbors.push({ "creditor": retLedger[idx]["IOU_List"][j]["creditor"], "amount": retLedger[idx]["IOU_List"][j]["amount"] });
		}
	}
	return neighbors;
}

// *Done* TODO: Return a list of all users (creditors or debtors) in the system
// You can return either:
//   - a list of everyone who has ever sent or received an IOU
// OR
//   - a list of everyone currently owing or being owed money
async function getUsers() {
	let useRecord = await findRecord();
	var users = new Set();
	for (var i = 0; i < useRecord.length; i++) {
		users.add(useRecord[i].debtor);
		for (var j = 0; j < useRecord[i].IOU_List.length; j++) {
			users.add(useRecord[i]["IOU_List"][j]["creditor"]);
		}
	}
	return Array.from(users);
}

// *Done* TODO: Get the total amount owed by the user specified by "user"
async function getTotalOwed(user) {
	let neighbors = await getNeighbors(user);
	var amount = 0;
	for (var i = 0; i < neighbors.length; i++) {
		amount += parseInt(neighbors[i]["amount"], 10);
	}
	return amount;
}

// TODO: Get the last time this user has sent or received an IOU, in seconds since Jan. 1, 1970
// Return null if you can't find any activity for the user.
// HINT: Try looking at the way 'getAllFunctionCalls' is written. You can modify it if you'd like.
async function getLastActive(user) {
	var curBlock = await web3.eth.getBlockNumber();

	while (curBlock !== GENESIS) {
		var my_block = await web3.eth.getBlock(curBlock, true);
		var timestamp = my_block.timestamp;
		var txns = my_block.transactions;
		for (var j = 0; j < txns.length; j++) {
			var txn = txns[j];

			if (txn.to != null && txn.from != null) {
				if (txn.to.toLowerCase() === user.toLowerCase() ||
					txn.from.toLowerCase() === user.toLowerCase()) {
					return timestamp;
				}
			}
		}
		curBlock = my_block.parentHash;
	}
	return null;
}

// TODO: add an IOU ('I owe you') to the system
// The person you owe money is passed as 'creditor'
// The amount you owe them is passed as 'amount'
//citation: the implementation below closely follow the tutorial here: 
//https://github.com/NOOMA-42/decentralized-splitwise/blob/master/Starter_Code/script.js
//to demonstrate understanding, I've added comments of each line to explain their functionality
async function add_IOU(creditor, amount) {

	//find a circle of debtors and creditors
	var ret = await doBFS(creditor, web3.eth.defaultAccount, getNeighbors);
	amount = parseInt(amount, 10);
	var response = false;
	//if the debtor and creditor do not form a circle
	if (ret != null) {
		//find the debtor's min debt, including the new IOU 
		let { loop, smallestAmountOwed } = ret;
		smallestAmountOwed = Math.min(parseInt(smallestAmountOwed, 10), amount);
		//error checking: see if the new amount will result in negative debt 
		for (var i = 0; i < loop.length; i++) {
			if (loop[i]["amount"] - smallestAmountOwed < 0) {
				return;
			}
		}
		//if the credit is from someone that I owe debt to, then we just do simple subtraction
		for (var i = 0; i < loop.length - 1; i++) {
			response = await BlockchainSplitwise.methods.add_IOU(loop[i + 1]["creditor"], -smallestAmountOwed).send({ from: loop[i]["creditor"], gas: 1000000 });
		}
		//if the credit is not from people that I owe money, then I just settle my current debt 
		response = await BlockchainSplitwise.methods.add_IOU(creditor, amount - smallestAmountOwed).send({ from: web3.eth.defaultAccount, gas: 1000000 });
	} else { // if don't have debt and I reveive credit, then simply add IOU
		response = await BlockchainSplitwise.methods.add_IOU(creditor, amount).send({ from: web3.eth.defaultAccount, gas: 1000000 });
	}
}

// ====================================
// 				Testing					
// ====================================
// Test your code during dev

// =============================================================================
//                              Provided Functions
// =============================================================================
// Reading and understanding these should help you implement the above

// This searches the block history for all calls to 'functionName' (string) on the 'addressOfContract' (string) contract
// It returns an array of objects, one for each call, containing the sender ('from'), arguments ('args'), and the timestamp ('t')
async function getAllFunctionCalls(addressOfContract, functionName) {
	var curBlock = await web3.eth.getBlockNumber();
	var function_calls = [];

	while (curBlock !== GENESIS) {
		var b = await web3.eth.getBlock(curBlock, true);
		var txns = b.transactions;
		for (var j = 0; j < txns.length; j++) {
			var txn = txns[j];

			// check that destination of txn is our contract
			if (txn.to == null) { continue; }
			if (txn.to.toLowerCase() === addressOfContract.toLowerCase()) {
				var func_call = abiDecoder.decodeMethod(txn.input);

				// check that the function getting called in this txn is 'functionName'
				if (func_call && func_call.name === functionName) {
					var time = await web3.eth.getBlock(curBlock);
					var args = func_call.params.map(function (x) { return x.value });
					function_calls.push({
						from: txn.from.toLowerCase(),
						args: args,
						t: time.timestamp
					})
				}
			}
		}
		curBlock = b.parentHash;
	}
	return function_calls;
}

// ** I've made a change that lastNode returned by getNeighbors with addr and amount.
// We've provided a breadth-first search implementation for you, if that's useful
// It will find a path from start to end (or return null if none exists)
// You just need to pass in a function ('getNeighbors') that takes a node (string) and returns its neighbors (as an array)
async function doBFS(start, end, getNeighbors) {
	var queue = [[{ "creditor": start, "amount": Number.MAX_SAFE_INTEGER }]]; // queue is a struct array 
	var smallestAmountOwed = Number.MAX_SAFE_INTEGER;
	while (queue.length > 0) {
		var cur = queue.shift();
		var lastNode = cur[cur.length - 1]
		if (lastNode["creditor"] === end) {
			for (var i = 0; i < cur.length; i++) {
				if (parseInt(cur[i]["amount"], 10) < parseInt(smallestAmountOwed, 10))
					smallestAmountOwed = cur[i]["amount"];
			}
			return { "loop": cur, "smallestAmountOwed": smallestAmountOwed };
		} else {
			var neighbors = await getNeighbors(lastNode["creditor"]);
			for (var i = 0; i < neighbors.length; i++) {
				queue.push(cur.concat([neighbors[i]]));
			}
		}
	}
	return null;
}

// =============================================================================
//                                      UI
// =============================================================================

// This sets the default account on load and displays the total owed to that
// account.
web3.eth.getAccounts().then((response) => {
	web3.eth.defaultAccount = response[0];

	getTotalOwed(web3.eth.defaultAccount).then((response) => {
		$("#total_owed").html("$" + response);
	});

	getLastActive(web3.eth.defaultAccount).then((response) => {
		time = timeConverter(response)
		$("#last_active").html(time)
	});
});

// This code updates the 'My Account' UI with the results of your functions
$("#myaccount").change(function () {
	web3.eth.defaultAccount = $(this).val();

	getTotalOwed(web3.eth.defaultAccount).then((response) => {
		$("#total_owed").html("$" + response);
	})

	getLastActive(web3.eth.defaultAccount).then((response) => {
		time = timeConverter(response)
		$("#last_active").html(time)
	});
});

// Allows switching between accounts in 'My Account' and the 'fast-copy' in 'Address of person you owe
web3.eth.getAccounts().then((response) => {
	var opts = response.map(function (a) {
		return '<option value="' +
			a.toLowerCase() + '">' + a.toLowerCase() + '</option>'
	});
	$(".account").html(opts);
	$(".wallet_addresses").html(response.map(function (a) { return '<li>' + a.toLowerCase() + '</li>' }));
});

// This code updates the 'Users' list in the UI with the results of your function
getUsers().then((response) => {
	$("#all_users").html(response.map(function (u, i) { return "<li>" + u + "</li>" }));
});

// This runs the 'add_IOU' function when you click the button
// It passes the values from the two inputs above
$("#addiou").click(function () {
	web3.eth.defaultAccount = $("#myaccount").val(); //sets the default account
	add_IOU($("#creditor").val(), $("#amount").val()).then((response) => {
		window.location.reload(true); // refreshes the page after add_IOU returns and the promise is unwrapped
	})
});

// This is a log function, provided if you want to display things to the page instead of the JavaScript console
// Pass in a discription of what you're printing, and then the object to print
function log(description, obj) {
	$("#log").html($("#log").html() + description + ": " + JSON.stringify(obj, null, 2) + "\n\n");
}


// =============================================================================
//                                      TESTING
// =============================================================================

// This section contains a sanity check test that you can use to ensure your code
// works. We will be testing your code this way, so make sure you at least pass
// the given test. You are encouraged to write more tests!

// Remember: the tests will assume that each of the four client functions are
// async functions and thus will return a promise. Make sure you understand what this means.

function check(name, condition) {
	if (condition) {
		console.log(name + ": SUCCESS");
		return 3;
	} else {
		console.log(name + ": FAILED");
		return 0;
	}
}

async function sanityCheck() {
	console.log("\nTEST", "Simplest possible test: only runs one add_IOU; uses all client functions: lookup, getTotalOwed, getUsers, getLastActive");

	var score = 0;

	var accounts = await web3.eth.getAccounts();
	web3.eth.defaultAccount = accounts[0];

	var users = await getUsers();
	score += check("getUsers() initially empty", users.length === 0);

	var owed = await getTotalOwed(accounts[0]);
	score += check("getTotalOwed(0) initially empty", owed === 0);

	var lookup_0_1 = await BlockchainSplitwise.methods.lookup(accounts[0], accounts[1]).call({ from: web3.eth.defaultAccount });
	score += check("lookup(0,1) initially 0", parseInt(lookup_0_1, 10) === 0);

	var response = await add_IOU(accounts[1], "10");

	users = await getUsers();
	score += check("getUsers() now length 2", users.length === 2);

	owed = await getTotalOwed(accounts[0]);
	score += check("getTotalOwed(0) now 10", owed === 10);

	lookup_0_1 = await BlockchainSplitwise.methods.lookup(accounts[0], accounts[1]).call({ from: web3.eth.defaultAccount });
	score += check("lookup(0,1) now 10", parseInt(lookup_0_1, 10) === 10);

	var timeLastActive = await getLastActive(accounts[0]);
	var timeNow = Date.now() / 1000;
	var difference = timeNow - timeLastActive;
	score += check("getLastActive(0) works", difference <= 60 && difference >= -3); // -3 to 60 seconds

	console.log("Final Score: " + score + "/21");
}

sanityCheck()


