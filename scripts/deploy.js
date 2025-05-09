const Web3 = require("web3");
const { abi, evm } = require("../build/Staking.json");
const web3 = new Web3("https://rinkeby.infura.io/v3/YOUR_INFURA_PROJECT_ID");
const account = "YOUR_WALLET_ADDRESS";
const privateKey = "YOUR_PRIVATE_KEY";

const deploy = async () => {
    const contract = new web3.eth.Contract(abi);

    const deployTransaction = contract.deploy({
        data: evm.bytecode.object,
        arguments: ["STAKING_TOKEN_ADDRESS", "REWARD_TOKEN_ADDRESS"]
    });

    const gas = await deployTransaction.estimateGas();
    const gasPrice = await web3.eth.getGasPrice();
    const data = deployTransaction.encodeABI();

    const tx = {
        from: account,
        data,
        gas,
        gasPrice,
        chainId: 4 // Rinkeby
    };

    const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);
    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    console.log("Contract deployed at address:", receipt.contractAddress);
};

deploy();

