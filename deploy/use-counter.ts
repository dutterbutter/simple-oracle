import { Provider } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";

// load env file
import dotenv from "dotenv";
dotenv.config();

// load contract artifact. Make sure to compile first!
import * as ContractArtifact from "../artifacts-zk/contracts/Counter.sol/Counter.json";

const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY || "";

if (!PRIVATE_KEY)
  throw "⛔️ Private key not detected! Add it to the .env file!";

// Address of the contract on zksync testnet
const CONTRACT_ADDRESS = "0xDb4b2E3D0fC32fB11bda3De2E182A1Cd635AEdC1";

if (!CONTRACT_ADDRESS) throw "⛔️ Contract address not provided";

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running script to interact with Counter contract ${CONTRACT_ADDRESS}`);

  // Initialize the provider.
  // @ts-ignore
  const provider = new Provider(hre.userConfig.networks?.zkSyncTestnet?.url);
  const signer = new ethers.Wallet(PRIVATE_KEY, provider);
  
  // Initialise contract instance
  const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    ContractArtifact.abi,
    signer
  );
  
  const estimatedGas = await contract.connect(signer).estimateGas.incrementCounterManyTimes(3);
  console.log(`Estimated units of gas for function:: ${estimatedGas.toString()}`);
  const gasPrice = await provider.getGasPrice();
  // Calculate total cost: gasPrice * estimatedGas
  const totalCost = gasPrice.mul(estimatedGas);
  const totalCostInEther = ethers.utils.formatEther(totalCost);
  console.log(`Estimated gas cost of function: ${totalCostInEther} ether`); 

  // estimate gas cost of function using estimateGasL1
  const transactionRequest = {
    to: CONTRACT_ADDRESS,
    from: signer.address,
    gasLimit: await contract.estimateGas.incrementCounterManyTimes(3),
    data: contract.interface.encodeFunctionData('incrementCounterManyTimes', [3]),
    value: ethers.utils.parseEther('0'),
  };
  const estimatedGasL1 = await provider.estimateGasL1(transactionRequest);
  console.log(`estimateGasL1:: Estimated units of gas for function::: ${estimatedGasL1.toString()}`);
  const totalCostL1 = gasPrice.mul(estimatedGasL1);
  const totalCostInEtherL1 = ethers.utils.formatEther(totalCostL1);
  console.log(`estimateGasL1:: gas cost of function: ${totalCostInEtherL1} ether`);
  
  // send transaction
  const tx = await contract.incrementCounterManyTimes(3);

  console.log(`Transaction to increment counter ${tx.hash}`);
  await tx.wait();

  const receipt = await tx.wait();
  console.log(`Actual gas used: ${receipt.gasUsed.toString()}`);
  console.log(`Estimated units of gas for function:: ${estimatedGas.toString()}`);
  
  const totalActualCost = gasPrice.mul(receipt.gasUsed);
  const totalActualCostInEther = ethers.utils.formatEther(totalActualCost);
  console.log(`Actual gas cost of function: ${totalActualCostInEther} ether`);
  console.log(`Estimated gas cost of function: ${totalCostInEther} ether`); 
}
