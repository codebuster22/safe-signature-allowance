/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  SignatureAllowance,
  SignatureAllowanceInterface,
} from "../../../src/SignatureAllowance/SignatureAllowance";

const _abi = [
  {
    inputs: [],
    name: "ModuleExecutionFailed",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "salt",
        type: "uint256",
      },
    ],
    name: "SaltAlreadyUsed",
    type: "error",
  },
  {
    inputs: [],
    name: "SignatureInactive",
    type: "error",
  },
  {
    inputs: [],
    name: "TokenAlreadyInAllowlist",
    type: "error",
  },
  {
    inputs: [],
    name: "TokenNotInAllowlist",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "previousAdmin",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "newAdmin",
        type: "address",
      },
    ],
    name: "AdminChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "beacon",
        type: "address",
      },
    ],
    name: "BeaconUpgraded",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "newDefaultToken",
        type: "address",
      },
    ],
    name: "DefaultTokenUpdated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "newExpiryPeriod",
        type: "uint256",
      },
    ],
    name: "ExpiryPeriodUpdated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint8",
        name: "version",
        type: "uint8",
      },
    ],
    name: "Initialized",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Paused",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [],
    name: "SafeModuleInitialized",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "contract Safe",
        name: "prevSafe",
        type: "address",
      },
      {
        indexed: false,
        internalType: "contract Safe",
        name: "newSafe",
        type: "address",
      },
    ],
    name: "TargetSafeUpdated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "newToken",
        type: "address",
      },
    ],
    name: "TokenAllowlistAppended",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "removedToken",
        type: "address",
      },
    ],
    name: "TokenRemovedFromAllowlist",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Unpaused",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "implementation",
        type: "address",
      },
    ],
    name: "Upgraded",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_newToken",
        type: "address",
      },
    ],
    name: "addTokenToAllowlist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
    ],
    name: "checkTokenAllowlisted",
    outputs: [
      {
        internalType: "bool",
        name: "_isAllowlisted",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "defaultToken",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
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
        name: "value",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
      {
        internalType: "enum Enum.Operation",
        name: "operation",
        type: "uint8",
      },
      {
        internalType: "uint256",
        name: "creationTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_salt",
        type: "uint256",
      },
    ],
    name: "encodeTransactionData",
    outputs: [
      {
        internalType: "bytes",
        name: "hashData",
        type: "bytes",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "expiryPeriod",
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
    name: "getDefaultToken",
    outputs: [
      {
        internalType: "address",
        name: "_defaultToken",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getSafe",
    outputs: [
      {
        internalType: "contract Safe",
        name: "_safe",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getSignatureExpiryPeriod",
    outputs: [
      {
        internalType: "uint256",
        name: "_expiryPeriod",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "contract Safe",
        name: "_safe",
        type: "address",
      },
      {
        internalType: "address",
        name: "_defaultToken",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_expiryPeriod",
        type: "uint256",
      },
    ],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_withdrawer",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "_signatures",
        type: "bytes",
      },
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_creationTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_salt",
        type: "uint256",
      },
    ],
    name: "isSignatureValid",
    outputs: [
      {
        internalType: "bool",
        name: "_isValid",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "paused",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "proxiableUUID",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
    ],
    name: "removeTokenFromAllowlist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "saltUsed",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_newDefaultToken",
        type: "address",
      },
    ],
    name: "setNewDefaultToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "contract Safe",
        name: "_newSafe",
        type: "address",
      },
    ],
    name: "setNewSafe",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_newExpiryPeriod",
        type: "uint256",
      },
    ],
    name: "setSignatureExpiryPeriod",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "tokensAllowed",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "unpause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newImplementation",
        type: "address",
      },
    ],
    name: "upgradeTo",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newImplementation",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "upgradeToAndCall",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_withdrawer",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "_signatures",
        type: "bytes",
      },
      {
        internalType: "uint256",
        name: "_creationTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_salt",
        type: "uint256",
      },
    ],
    name: "withdrawAllowanceDefaultToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_withdrawer",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "_signatures",
        type: "bytes",
      },
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_creationTime",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_salt",
        type: "uint256",
      },
    ],
    name: "withdrawAllowanceFromToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60a06040523060805234801561001457600080fd5b5060805161221861004c600039600081816107ff0152818161088401528181610a8401528181610b090152610d3d01526122186000f3fe6080604052600436106101ac5760003560e01c80635c975abb116100ec578063b1cfab691161008a578063ea01b25511610064578063ea01b255146104b1578063eeda452b146104c6578063f2fde38b146104f6578063f803f8e11461051657600080fd5b8063b1cfab6914610443578063b920bed314610473578063c6e115961461049357600080fd5b806374c13fda116100c657806374c13fda146103b75780638456cb59146103d75780638da5cb5b146103ec5780638e5e0e1c1461040a57600080fd5b80635c975abb1461034657806368bc573e1461036a578063715018a6146103a257600080fd5b80633d2cf8b2116101595780634f1ef286116101335780634f1ef286146102d15780634f91f2e9146102e457806352d1902d1461031157806359ff6d3b1461032657600080fd5b80633d2cf8b2146102735780633dcaa2c01461029c5780633f4ba83a146102bc57600080fd5b80631a5636fd1161018a5780631a5636fd146102135780631df99529146102335780633659cfe61461025357600080fd5b80630d4a2809146101b15780631794bb3c146101d35780631957fba4146101f3575b600080fd5b3480156101bd57600080fd5b506101d16101cc366004611cdd565b610536565b005b3480156101df57600080fd5b506101d16101ee366004611d01565b61054a565b3480156101ff57600080fd5b506101d161020e366004611cdd565b6106d7565b34801561021f57600080fd5b506101d161022e366004611d42565b610789565b34801561023f57600080fd5b506101d161024e366004611da4565b6107c6565b34801561025f57600080fd5b506101d161026e366004611cdd565b6107f5565b34801561027f57600080fd5b5061028960fc5481565b6040519081526020015b60405180910390f35b3480156102a857600080fd5b506101d16102b7366004611e12565b61096d565b3480156102c857600080fd5b506101d1610a60565b6101d16102df366004611f3b565b610a7a565b3480156102f057600080fd5b506103046102ff366004611f8b565b610be6565b604051610293919061205d565b34801561031d57600080fd5b50610289610d30565b34801561033257600080fd5b506101d1610341366004611cdd565b610df5565b34801561035257600080fd5b5060655460ff165b6040519015158152602001610293565b34801561037657600080fd5b506000546201000090046001600160a01b03165b6040516001600160a01b039091168152602001610293565b3480156103ae57600080fd5b506101d1610ea4565b3480156103c357600080fd5b5060fb5461038a906001600160a01b031681565b3480156103e357600080fd5b506101d1610eb6565b3480156103f857600080fd5b506033546001600160a01b031661038a565b34801561041657600080fd5b5061035a610425366004611cdd565b6001600160a01b0316600090815260fe602052604090205460ff1690565b34801561044f57600080fd5b5061035a61045e366004611d42565b60fd6020526000908152604090205460ff1681565b34801561047f57600080fd5b5061035a61048e366004611e12565b610ece565b34801561049f57600080fd5b5060fb546001600160a01b031661038a565b3480156104bd57600080fd5b5060fc54610289565b3480156104d257600080fd5b5061035a6104e1366004611cdd565b60fe6020526000908152604090205460ff1681565b34801561050257600080fd5b506101d1610511366004611cdd565b610fca565b34801561052257600080fd5b506101d1610531366004611cdd565b611057565b61053e611068565b610547816110c2565b50565b600054610100900460ff161580801561056a5750600054600160ff909116105b806105845750303b158015610584575060005460ff166001145b6105fb5760405162461bcd60e51b815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201527f647920696e697469616c697a656400000000000000000000000000000000000060648201526084015b60405180910390fd5b6000805460ff19166001179055801561061e576000805461ff0019166101001790555b610627846111c9565b61062f611269565b610638846112dc565b61064061133b565b6106486113ae565b61065183611419565b60fc8290556000805260fd6020527fc34a738ec333e394a3927794cadc6dd0eb7d9eed0999d1e55021ea223ac362cc805460ff1916600117905580156106d1576000805461ff0019169055604051600181527f7f26b83ff96e1f2b6a682f133852f6798a09c465da95921460cefb38474024989060200160405180910390a15b50505050565b6106df611068565b6001600160a01b038116600090815260fe602052604090205460ff16610731576040517f847169f600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6001600160a01b038116600081815260fe6020908152604091829020805460ff1916905590519182527ff5185b73ca401917cf16614454ea0b2c62433672aa4fd77e6778fae59c69ac0691015b60405180910390a150565b610791611068565b60fc8190556040518181527fac398dfada634e20e24bc19d51a482c8485b039b02e65805f36848e4587d03409060200161077e565b6107ce6114ec565b60fb546107ed9087908790879087906001600160a01b0316878761096d565b505050505050565b6001600160a01b037f00000000000000000000000000000000000000000000000000000000000000001630036108825760405162461bcd60e51b815260206004820152602c60248201527f46756e6374696f6e206d7573742062652063616c6c6564207468726f7567682060448201526b19195b1959d85d1958d85b1b60a21b60648201526084016105f2565b7f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03166108dd7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc546001600160a01b031690565b6001600160a01b0316146109485760405162461bcd60e51b815260206004820152602c60248201527f46756e6374696f6e206d7573742062652063616c6c6564207468726f7567682060448201526b6163746976652070726f787960a01b60648201526084016105f2565b6109518161153f565b6040805160008082526020820190925261054791839190611547565b6109756114ec565b600081815260fd602052604090205460ff16156109c1576040517f43baf26e000000000000000000000000000000000000000000000000000000008152600481018290526024016105f2565b6109d087878787878787610ece565b50600081815260fd602090815260408083208054600160ff1990911617905580516001600160a01b038a16602482015260448082018c905282518083039091018152606490910190915290810180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1663a9059cbb60e01b17905290610a5690859083816116ec565b5050505050505050565b610a686117c4565b610a70611068565b610a78611816565b565b6001600160a01b037f0000000000000000000000000000000000000000000000000000000000000000163003610b075760405162461bcd60e51b815260206004820152602c60248201527f46756e6374696f6e206d7573742062652063616c6c6564207468726f7567682060448201526b19195b1959d85d1958d85b1b60a21b60648201526084016105f2565b7f00000000000000000000000000000000000000000000000000000000000000006001600160a01b0316610b627f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc546001600160a01b031690565b6001600160a01b031614610bcd5760405162461bcd60e51b815260206004820152602c60248201527f46756e6374696f6e206d7573742062652063616c6c6564207468726f7567682060448201526b6163746976652070726f787960a01b60648201526084016105f2565b610bd68261153f565b610be282826001611547565b5050565b60606000610c036000546001600160a01b03620100009091041690565b905060007fd4c5d3046bae148fd11b1f1b0767eafdff0d9472e80787e75f15de5337d4bed689898980519060200120898989604051602001610c4b9796959493929190612092565b604051602081830303815290604052805190602001209050601960f81b600160f81b836001600160a01b031663f698da256040518163ffffffff1660e01b8152600401602060405180830381865afa158015610cab573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610ccf91906120d8565b6040517fff000000000000000000000000000000000000000000000000000000000000009384166020820152929091166021830152602282015260428101829052606201604051602081830303815290604052925050509695505050505050565b6000306001600160a01b037f00000000000000000000000000000000000000000000000000000000000000001614610dd05760405162461bcd60e51b815260206004820152603860248201527f555550535570677261646561626c653a206d757374206e6f742062652063616c60448201527f6c6564207468726f7567682064656c656761746563616c6c000000000000000060648201526084016105f2565b507f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc90565b610dfd611068565b6001600160a01b038116600090815260fe602052604090205460ff1615610e50576040517f41b0d5b100000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6001600160a01b038116600081815260fe6020908152604091829020805460ff1916600117905590519182527fcb28ee438d6cdf0e68b9814e11fc8af69d83e51181d097df2658d91c13e0b04a910161077e565b610eac611068565b610a7860006112dc565b610ebe6114ec565b610ec6611068565b610a78611868565b604080516001600160a01b038816602482015260448082018a90528251808303909101815260649091019091526020810180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1663a9059cbb60e01b17905260fc5460009190610f3b85426120f1565b1115610f73576040517fb4ee580d00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b610fba85600083600088888d8d8080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152506118a592505050565b5060019998505050505050505050565b610fd2611068565b6001600160a01b03811661104e5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201527f646472657373000000000000000000000000000000000000000000000000000060648201526084016105f2565b610547816112dc565b61105f611068565b61054781611419565b6033546001600160a01b03163314610a785760405162461bcd60e51b815260206004820181905260248201527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e657260448201526064016105f2565b6040517fef6770c70000000000000000000000000000000000000000000000000000000081526001600160a01b038216600482015273__$206f43c279fc6f9611d7f8cb379e894b6c$__9063ef6770c79060240160006040518083038186803b15801561112e57600080fd5b505af4158015611142573d6000803e3d6000fd5b5050600080546001600160a01b03858116620100008181027fffffffffffffffffffff0000000000000000000000000000000000000000ffff8516179094556040805194909304909116808452602084019190915293507f323c15799dd924c260c0c57bf06702fb348532840fcb54404ab0a511cd5ce15392500160405180910390a15050565b600054610100900460ff166112345760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016105f2565b61123d816110c2565b6040517f9e13a003998330f14d4ad1006f7757ce0bda4d1ef86a37f5f8f08e0d5e32042190600090a150565b600054610100900460ff166112d45760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016105f2565b610a7861195c565b603380546001600160a01b0383811673ffffffffffffffffffffffffffffffffffffffff19831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b600054610100900460ff166113a65760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016105f2565b610a786119d0565b600054610100900460ff16610a785760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016105f2565b6001600160a01b038116600090815260fe602052604090205460ff16611491576001600160a01b038116600081815260fe6020908152604091829020805460ff1916600117905590519182527fcb28ee438d6cdf0e68b9814e11fc8af69d83e51181d097df2658d91c13e0b04a910160405180910390a15b60fb805473ffffffffffffffffffffffffffffffffffffffff19166001600160a01b0383169081179091556040519081527f2ffae89a4970d1ff9bf1a765b00d7eee23cd328cdaaab85b7ce9e5379c1ece329060200161077e565b60655460ff1615610a785760405162461bcd60e51b815260206004820152601060248201527f5061757361626c653a207061757365640000000000000000000000000000000060448201526064016105f2565b610547611068565b7f4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd91435460ff161561157f5761157a83611a47565b505050565b826001600160a01b03166352d1902d6040518163ffffffff1660e01b8152600401602060405180830381865afa9250505080156115d9575060408051601f3d908101601f191682019092526115d6918101906120d8565b60015b61164b5760405162461bcd60e51b815260206004820152602e60248201527f45524331393637557067726164653a206e657720696d706c656d656e7461746960448201527f6f6e206973206e6f74205555505300000000000000000000000000000000000060648201526084016105f2565b7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc81146116e05760405162461bcd60e51b815260206004820152602960248201527f45524331393637557067726164653a20756e737570706f727465642070726f7860448201527f6961626c6555554944000000000000000000000000000000000000000000000060648201526084016105f2565b5061157a838383611b12565b600080546040517f468721a7000000000000000000000000000000000000000000000000000000008152620100009091046001600160a01b03169063468721a790611741908890889088908890600401612112565b6020604051808303816000875af1158015611760573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906117849190612152565b9050806117bd576040517fcce1466600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5050505050565b60655460ff16610a785760405162461bcd60e51b815260206004820152601460248201527f5061757361626c653a206e6f742070617573656400000000000000000000000060448201526064016105f2565b61181e6117c4565b6065805460ff191690557f5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa335b6040516001600160a01b03909116815260200160405180910390a1565b6118706114ec565b6065805460ff191660011790557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a25861184b3390565b600080546201000090046001600160a01b0316816118c78a8a8a8a8a8a610be6565b805160208201206040517f934f3a11000000000000000000000000000000000000000000000000000000008152919250906001600160a01b0384169063934f3a119061191b90849086908a90600401612174565b60006040518083038186803b15801561193357600080fd5b505afa158015611947573d6000803e3d6000fd5b5060019e9d5050505050505050505050505050565b600054610100900460ff166119c75760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016105f2565b610a78336112dc565b600054610100900460ff16611a3b5760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016105f2565b6065805460ff19169055565b6001600160a01b0381163b611ac45760405162461bcd60e51b815260206004820152602d60248201527f455243313936373a206e657720696d706c656d656e746174696f6e206973206e60448201527f6f74206120636f6e74726163740000000000000000000000000000000000000060648201526084016105f2565b7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc805473ffffffffffffffffffffffffffffffffffffffff19166001600160a01b0392909216919091179055565b611b1b83611b37565b600082511180611b285750805b1561157a576106d18383611b77565b611b4081611a47565b6040516001600160a01b038216907fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b90600090a250565b6060611b9c83836040518060600160405280602781526020016121bc60279139611ba5565b90505b92915050565b6060600080856001600160a01b031685604051611bc2919061219f565b600060405180830381855af49150503d8060008114611bfd576040519150601f19603f3d011682016040523d82523d6000602084013e611c02565b606091505b5091509150611c1386838387611c1d565b9695505050505050565b60608315611c8c578251600003611c85576001600160a01b0385163b611c855760405162461bcd60e51b815260206004820152601d60248201527f416464726573733a2063616c6c20746f206e6f6e2d636f6e747261637400000060448201526064016105f2565b5081611c96565b611c968383611c9e565b949350505050565b815115611cae5781518083602001fd5b8060405162461bcd60e51b81526004016105f2919061205d565b6001600160a01b038116811461054757600080fd5b600060208284031215611cef57600080fd5b8135611cfa81611cc8565b9392505050565b600080600060608486031215611d1657600080fd5b8335611d2181611cc8565b92506020840135611d3181611cc8565b929592945050506040919091013590565b600060208284031215611d5457600080fd5b5035919050565b60008083601f840112611d6d57600080fd5b50813567ffffffffffffffff811115611d8557600080fd5b602083019150836020828501011115611d9d57600080fd5b9250929050565b60008060008060008060a08789031215611dbd57600080fd5b863595506020870135611dcf81611cc8565b9450604087013567ffffffffffffffff811115611deb57600080fd5b611df789828a01611d5b565b979a9699509760608101359660809091013595509350505050565b600080600080600080600060c0888a031215611e2d57600080fd5b873596506020880135611e3f81611cc8565b9550604088013567ffffffffffffffff811115611e5b57600080fd5b611e678a828b01611d5b565b9096509450506060880135611e7b81611cc8565b969995985093969295946080840135945060a09093013592915050565b634e487b7160e01b600052604160045260246000fd5b600082601f830112611ebf57600080fd5b813567ffffffffffffffff80821115611eda57611eda611e98565b604051601f8301601f19908116603f01168101908282118183101715611f0257611f02611e98565b81604052838152866020858801011115611f1b57600080fd5b836020870160208301376000602085830101528094505050505092915050565b60008060408385031215611f4e57600080fd5b8235611f5981611cc8565b9150602083013567ffffffffffffffff811115611f7557600080fd5b611f8185828601611eae565b9150509250929050565b60008060008060008060c08789031215611fa457600080fd5b8635611faf81611cc8565b955060208701359450604087013567ffffffffffffffff811115611fd257600080fd5b611fde89828a01611eae565b945050606087013560028110611ff357600080fd5b9598949750929560808101359460a0909101359350915050565b60005b83811015612028578181015183820152602001612010565b50506000910152565b6000815180845261204981602086016020860161200d565b601f01601f19169290920160200192915050565b602081526000611b9c6020830184612031565b6002811061208e57634e487b7160e01b600052602160045260246000fd5b9052565b8781526001600160a01b0387166020820152604081018690526060810185905260e081016120c36080830186612070565b60a082019390935260c0015295945050505050565b6000602082840312156120ea57600080fd5b5051919050565b81810381811115611b9f57634e487b7160e01b600052601160045260246000fd5b6001600160a01b038516815283602082015260806040820152600061213a6080830185612031565b90506121496060830184612070565b95945050505050565b60006020828403121561216457600080fd5b81518015158114611cfa57600080fd5b83815260606020820152600061218d6060830185612031565b8281036040840152611c138185612031565b600082516121b181846020870161200d565b919091019291505056fe416464726573733a206c6f772d6c6576656c2064656c65676174652063616c6c206661696c6564a2646970667358221220e27ff2e6502f969e152394e92900b6a0792de578c1d55960cda200ea1645e05f64736f6c63430008130033";

type SignatureAllowanceConstructorParams =
  | [linkLibraryAddresses: SignatureAllowanceLibraryAddresses, signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: SignatureAllowanceConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => {
  return (
    typeof xs[0] === "string" ||
    (Array.isArray as (arg: any) => arg is readonly any[])(xs[0]) ||
    "_isInterface" in xs[0]
  );
};

export class SignatureAllowance__factory extends ContractFactory {
  constructor(...args: SignatureAllowanceConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      const [linkLibraryAddresses, signer] = args;
      super(
        _abi,
        SignatureAllowance__factory.linkBytecode(linkLibraryAddresses),
        signer
      );
    }
  }

  static linkBytecode(
    linkLibraryAddresses: SignatureAllowanceLibraryAddresses
  ): string {
    let linkedBytecode = _bytecode;

    linkedBytecode = linkedBytecode.replace(
      new RegExp("__\\$206f43c279fc6f9611d7f8cb379e894b6c\\$__", "g"),
      linkLibraryAddresses["src/SafeModule/SafeModule.sol:ContractChecker"]
        .replace(/^0x/, "")
        .toLowerCase()
    );

    return linkedBytecode;
  }

  override deploy(
    overrides?: Overrides & { from?: string }
  ): Promise<SignatureAllowance> {
    return super.deploy(overrides || {}) as Promise<SignatureAllowance>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: string }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): SignatureAllowance {
    return super.attach(address) as SignatureAllowance;
  }
  override connect(signer: Signer): SignatureAllowance__factory {
    return super.connect(signer) as SignatureAllowance__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): SignatureAllowanceInterface {
    return new utils.Interface(_abi) as SignatureAllowanceInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): SignatureAllowance {
    return new Contract(address, _abi, signerOrProvider) as SignatureAllowance;
  }
}

export interface SignatureAllowanceLibraryAddresses {
  ["src/SafeModule/SafeModule.sol:ContractChecker"]: string;
}
