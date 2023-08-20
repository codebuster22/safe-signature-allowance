/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { GM, GMInterface } from "../../src/GM";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_receiver",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [],
    name: "HUNDRED_MILLION",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
    ],
    name: "allowance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "decimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "subtractedValue",
        type: "uint256",
      },
    ],
    name: "decreaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "addedValue",
        type: "uint256",
      },
    ],
    name: "increaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60806040523480156200001157600080fd5b5060405162000cb438038062000cb483398101604081905262000034916200016f565b604080518082018252600280825261474d60f01b60208084018290528451808601909552918452908301529060036200006e838262000245565b5060046200007d828262000245565b5050506200009d816a52b7d2dcc80cd2e4000000620000a460201b60201c565b5062000339565b6001600160a01b038216620000ff5760405162461bcd60e51b815260206004820152601f60248201527f45524332303a206d696e7420746f20746865207a65726f206164647265737300604482015260640160405180910390fd5b806002600082825462000113919062000311565b90915550506001600160a01b038216600081815260208181526040808320805486019055518481527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a35050565b505050565b6000602082840312156200018257600080fd5b81516001600160a01b03811681146200019a57600080fd5b9392505050565b634e487b7160e01b600052604160045260246000fd5b600181811c90821680620001cc57607f821691505b602082108103620001ed57634e487b7160e01b600052602260045260246000fd5b50919050565b601f8211156200016a57600081815260208120601f850160051c810160208610156200021c5750805b601f850160051c820191505b818110156200023d5782815560010162000228565b505050505050565b81516001600160401b03811115620002615762000261620001a1565b6200027981620002728454620001b7565b84620001f3565b602080601f831160018114620002b15760008415620002985750858301515b600019600386901b1c1916600185901b1785556200023d565b600085815260208120601f198616915b82811015620002e257888601518255948401946001909101908401620002c1565b5085821015620003015787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b808201808211156200033357634e487b7160e01b600052601160045260246000fd5b92915050565b61096b80620003496000396000f3fe608060405234801561001057600080fd5b50600436106100d45760003560e01c80633950935111610081578063a457c2d71161005b578063a457c2d7146101a4578063a9059cbb146101b7578063dd62ed3e146101ca57600080fd5b8063395093511461016057806370a082311461017357806395d89b411461019c57600080fd5b80631fe748a4116100b25780631fe748a41461012c57806323b872dd1461013e578063313ce5671461015157600080fd5b806306fdde03146100d9578063095ea7b3146100f757806318160ddd1461011a575b600080fd5b6100e1610203565b6040516100ee91906107b5565b60405180910390f35b61010a61010536600461081f565b610295565b60405190151581526020016100ee565b6002545b6040519081526020016100ee565b61011e6a52b7d2dcc80cd2e400000081565b61010a61014c366004610849565b6102af565b604051601281526020016100ee565b61010a61016e36600461081f565b6102d3565b61011e610181366004610885565b6001600160a01b031660009081526020819052604090205490565b6100e1610312565b61010a6101b236600461081f565b610321565b61010a6101c536600461081f565b6103d0565b61011e6101d83660046108a7565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205490565b606060038054610212906108da565b80601f016020809104026020016040519081016040528092919081815260200182805461023e906108da565b801561028b5780601f106102605761010080835404028352916020019161028b565b820191906000526020600020905b81548152906001019060200180831161026e57829003601f168201915b5050505050905090565b6000336102a38185856103de565b60019150505b92915050565b6000336102bd858285610536565b6102c88585856105c8565b506001949350505050565b3360008181526001602090815260408083206001600160a01b03871684529091528120549091906102a3908290869061030d908790610914565b6103de565b606060048054610212906108da565b3360008181526001602090815260408083206001600160a01b0387168452909152812054909190838110156103c35760405162461bcd60e51b815260206004820152602560248201527f45524332303a2064656372656173656420616c6c6f77616e63652062656c6f7760448201527f207a65726f00000000000000000000000000000000000000000000000000000060648201526084015b60405180910390fd5b6102c882868684036103de565b6000336102a38185856105c8565b6001600160a01b0383166104595760405162461bcd60e51b8152602060048201526024808201527f45524332303a20617070726f76652066726f6d20746865207a65726f2061646460448201527f726573730000000000000000000000000000000000000000000000000000000060648201526084016103ba565b6001600160a01b0382166104d55760405162461bcd60e51b815260206004820152602260248201527f45524332303a20617070726f766520746f20746865207a65726f20616464726560448201527f737300000000000000000000000000000000000000000000000000000000000060648201526084016103ba565b6001600160a01b0383811660008181526001602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925910160405180910390a3505050565b6001600160a01b0383811660009081526001602090815260408083209386168352929052205460001981146105c257818110156105b55760405162461bcd60e51b815260206004820152601d60248201527f45524332303a20696e73756666696369656e7420616c6c6f77616e636500000060448201526064016103ba565b6105c284848484036103de565b50505050565b6001600160a01b0383166106445760405162461bcd60e51b815260206004820152602560248201527f45524332303a207472616e736665722066726f6d20746865207a65726f20616460448201527f647265737300000000000000000000000000000000000000000000000000000060648201526084016103ba565b6001600160a01b0382166106c05760405162461bcd60e51b815260206004820152602360248201527f45524332303a207472616e7366657220746f20746865207a65726f206164647260448201527f657373000000000000000000000000000000000000000000000000000000000060648201526084016103ba565b6001600160a01b0383166000908152602081905260409020548181101561074f5760405162461bcd60e51b815260206004820152602660248201527f45524332303a207472616e7366657220616d6f756e742065786365656473206260448201527f616c616e6365000000000000000000000000000000000000000000000000000060648201526084016103ba565b6001600160a01b03848116600081815260208181526040808320878703905593871680835291849020805487019055925185815290927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a36105c2565b600060208083528351808285015260005b818110156107e2578581018301518582016040015282016107c6565b506000604082860101526040601f19601f8301168501019250505092915050565b80356001600160a01b038116811461081a57600080fd5b919050565b6000806040838503121561083257600080fd5b61083b83610803565b946020939093013593505050565b60008060006060848603121561085e57600080fd5b61086784610803565b925061087560208501610803565b9150604084013590509250925092565b60006020828403121561089757600080fd5b6108a082610803565b9392505050565b600080604083850312156108ba57600080fd5b6108c383610803565b91506108d160208401610803565b90509250929050565b600181811c908216806108ee57607f821691505b60208210810361090e57634e487b7160e01b600052602260045260246000fd5b50919050565b808201808211156102a957634e487b7160e01b600052601160045260246000fdfea2646970667358221220e30839198e02dba289628045efaea344429e0ce2ad11109ffbb07c6bde5b0d0664736f6c63430008130033";

type GMConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: GMConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class GM__factory extends ContractFactory {
  constructor(...args: GMConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _receiver: string,
    overrides?: Overrides & { from?: string }
  ): Promise<GM> {
    return super.deploy(_receiver, overrides || {}) as Promise<GM>;
  }
  override getDeployTransaction(
    _receiver: string,
    overrides?: Overrides & { from?: string }
  ): TransactionRequest {
    return super.getDeployTransaction(_receiver, overrides || {});
  }
  override attach(address: string): GM {
    return super.attach(address) as GM;
  }
  override connect(signer: Signer): GM__factory {
    return super.connect(signer) as GM__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): GMInterface {
    return new utils.Interface(_abi) as GMInterface;
  }
  static connect(address: string, signerOrProvider: Signer | Provider): GM {
    return new Contract(address, _abi, signerOrProvider) as GM;
  }
}
