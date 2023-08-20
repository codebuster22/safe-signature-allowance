/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
} from "../../common";

export interface SignatureAllowanceStorageInterface extends utils.Interface {
  functions: {
    "defaultToken()": FunctionFragment;
    "expiryPeriod()": FunctionFragment;
    "saltUsed(uint256)": FunctionFragment;
    "tokensAllowed(address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "defaultToken"
      | "expiryPeriod"
      | "saltUsed"
      | "tokensAllowed"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "defaultToken",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "expiryPeriod",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "saltUsed",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "tokensAllowed",
    values: [string]
  ): string;

  decodeFunctionResult(
    functionFragment: "defaultToken",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "expiryPeriod",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "saltUsed", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "tokensAllowed",
    data: BytesLike
  ): Result;

  events: {};
}

export interface SignatureAllowanceStorage extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: SignatureAllowanceStorageInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    defaultToken(overrides?: CallOverrides): Promise<[string]>;

    expiryPeriod(overrides?: CallOverrides): Promise<[BigNumber]>;

    saltUsed(arg0: BigNumberish, overrides?: CallOverrides): Promise<[boolean]>;

    tokensAllowed(arg0: string, overrides?: CallOverrides): Promise<[boolean]>;
  };

  defaultToken(overrides?: CallOverrides): Promise<string>;

  expiryPeriod(overrides?: CallOverrides): Promise<BigNumber>;

  saltUsed(arg0: BigNumberish, overrides?: CallOverrides): Promise<boolean>;

  tokensAllowed(arg0: string, overrides?: CallOverrides): Promise<boolean>;

  callStatic: {
    defaultToken(overrides?: CallOverrides): Promise<string>;

    expiryPeriod(overrides?: CallOverrides): Promise<BigNumber>;

    saltUsed(arg0: BigNumberish, overrides?: CallOverrides): Promise<boolean>;

    tokensAllowed(arg0: string, overrides?: CallOverrides): Promise<boolean>;
  };

  filters: {};

  estimateGas: {
    defaultToken(overrides?: CallOverrides): Promise<BigNumber>;

    expiryPeriod(overrides?: CallOverrides): Promise<BigNumber>;

    saltUsed(arg0: BigNumberish, overrides?: CallOverrides): Promise<BigNumber>;

    tokensAllowed(arg0: string, overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    defaultToken(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    expiryPeriod(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    saltUsed(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    tokensAllowed(
      arg0: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}