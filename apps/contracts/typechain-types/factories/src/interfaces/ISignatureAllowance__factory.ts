/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  ISignatureAllowance,
  ISignatureAllowanceInterface,
} from "../../../src/interfaces/ISignatureAllowance";

const _abi = [
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

export class ISignatureAllowance__factory {
  static readonly abi = _abi;
  static createInterface(): ISignatureAllowanceInterface {
    return new utils.Interface(_abi) as ISignatureAllowanceInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ISignatureAllowance {
    return new Contract(address, _abi, signerOrProvider) as ISignatureAllowance;
  }
}