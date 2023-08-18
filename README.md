# Safe Signature Allowance Module

## About

This is the repository for a Safe Module that can allow non-signers to withdraw specific amount of tokens from a defined Safe upon receiving a valid and active (not expired) signature(s) of threshold signers.

## User Personas and Entities
All entities interacting in the project can be categorised as following
1. `SafeSigner`: An EOA or smart contract account that is one of the Signer of a Safe.
2. `Withdrawer`: An EOA or smart contract account that is going to withdraw defined number of tokens from the `SignatureAllowance` module upon receiving valid and active signature.
3. `Safe`: A plain old safe multi-sig contract.
4. `SignatureAllowance` (Safe Module): A Safe Module that manages and executes the withdrawal of GM tokens from `Safe` upon valid requirements checks.
5. `GM` (ERC20): An ERC20 token that will be transferred from `Safe` to `Withdrawer` by `SignatureAllowance`.

## Functional Requirements
1. `GM` token should be a simple ERC20 token.
2. Once `GM` token is deployed, transfer 100M tokens to `Safe`.
3. `Safe` should have `SignatureAllowance` added as valid module.
4. `SignatureAllowance` should be owned by `Safe`.
5. `SignatureAllowance` should interact with `Safe` using `ModuleManager` interface.
6. `SignatureAllowance` should be able to handle withdrawal of multiple ERC20 tokens.
6. `SignatureAllowance` should only be able to withdraw tokens from one `Safe` only.
7. `SignatureAllowance` should implement a withdraw function that accepts following parameters.
    a. amount of tokens: Amount of tokens to be withdrawen.
    b. receiver address: Address of Withdrawer
    c. signature(s): A concatenated signature string of x signatures where x is the number of signers greater than Threshold signers.
    d. token address: address of token to be withdrawn
This function should generate a withdrawal hash (`keccak(AmountOfTokens, receiverAddress, salt, tokenAddress)`).
8. `SignatureAllowance` should use a salt for each withdrawal request to prevent replay attacks.
9. `SignatureAllowance` should use `blocknumber` instead of `time` to prevent miners from making the signature inactive. Estimate number of blocknumbers for the given valid time period.
10. `SignatureAllowance` should implement a function to change Safe address.
11. `SignatureAllowance` should implement a function to add and remove tokens that can be withdrawn.
12. `SignatureAllowance` should be deployed as UUPS proxy.
13. `SignatureAllowance` should support EIP1271 signatures to allow smart contract signatures.

## Acceptance Criteria
- [] A withdrawer should be able to withdraw X amount of Token A given the signature is valid and active.
- [] A withdrawer should not be able to withdraw if the signature is:
    - [] Invalid
    - [] Valid but inactive
    - If Signature is invalid, no way of checking if the signature is active or not.
- [] A SafeSigner can add new tokens to `SignatureAllowance` via Safe.
- [] A SafeSigner cannot directly add new tokens to `SignatureAllowance`.
- [] A SafeSigner can remove tokens from `SignatureAllowance` via Safe.
- [] A SafeSigner cannot directly remove tokens from `SignatureAllowance`.
- [] A SafeSigner cannot change owner of the `SignatureAllowance` directly.
- [] SignatureAllowance can handle EIP1271 signature as well.
- [] SignatureAllowance can handle 1 and more than 1 threshold signatures.

## Project Stucture
To be added after project completion.

## Tech Stack

### Smart Contracts
Dev Tool: Hardhat combined with Foundry
Smart Contract Language: Solidity
Development Language: TypeScript

### Indexer
Indexing Tool: The Graph
Development Langauge: TypeScript

### Frontend
Framework: React (Create Vite App)
Development Language: TypeScript & TSX

### Dev Tooling
`cast`: Interact with smart contract from command line.
`anvil`: Local testing
`Tenderly`: Tracing contract interaction on test networks.

