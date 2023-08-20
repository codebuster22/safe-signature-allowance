/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type { BaseContract, Signer, utils } from "ethers";
import type { EventFragment } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
} from "../../../common";

export interface SafeModuleInterface extends utils.Interface {
  functions: {};

  events: {
    "Initialized(uint8)": EventFragment;
    "SafeModuleInitialized()": EventFragment;
    "TargetSafeUpdated(address,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "Initialized"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "SafeModuleInitialized"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "TargetSafeUpdated"): EventFragment;
}

export interface InitializedEventObject {
  version: number;
}
export type InitializedEvent = TypedEvent<[number], InitializedEventObject>;

export type InitializedEventFilter = TypedEventFilter<InitializedEvent>;

export interface SafeModuleInitializedEventObject {}
export type SafeModuleInitializedEvent = TypedEvent<
  [],
  SafeModuleInitializedEventObject
>;

export type SafeModuleInitializedEventFilter =
  TypedEventFilter<SafeModuleInitializedEvent>;

export interface TargetSafeUpdatedEventObject {
  prevSafe: string;
  newSafe: string;
}
export type TargetSafeUpdatedEvent = TypedEvent<
  [string, string],
  TargetSafeUpdatedEventObject
>;

export type TargetSafeUpdatedEventFilter =
  TypedEventFilter<TargetSafeUpdatedEvent>;

export interface SafeModule extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: SafeModuleInterface;

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

  functions: {};

  callStatic: {};

  filters: {
    "Initialized(uint8)"(version?: null): InitializedEventFilter;
    Initialized(version?: null): InitializedEventFilter;

    "SafeModuleInitialized()"(): SafeModuleInitializedEventFilter;
    SafeModuleInitialized(): SafeModuleInitializedEventFilter;

    "TargetSafeUpdated(address,address)"(
      prevSafe?: null,
      newSafe?: null
    ): TargetSafeUpdatedEventFilter;
    TargetSafeUpdated(
      prevSafe?: null,
      newSafe?: null
    ): TargetSafeUpdatedEventFilter;
  };

  estimateGas: {};

  populateTransaction: {};
}