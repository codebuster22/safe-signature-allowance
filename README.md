# Safe Signature Allowance Module

## Demo
[See Demo on Loom](https://www.loom.com/share/af9a7b04c3974268bf50c6b5c5db52c8?sid=f6950575-6140-42fc-bfaa-fea2c299a81b)

## Prerequisites:
1. [foundry](https://book.getfoundry.sh/getting-started/installation)
2. [yarn](https://yarnpkg.com/getting-started/install)

## Setup

1. Install Dependencies
```
yarn install
```

2. Navigate to `contracts` workspace
```
cd apps/contracts
```

3. Create an `.env` file.
```
touch .env
```

4. Add enviornment variables, you can look into `.env.example` for the enviornment variables needed.
```
INFURA_KEY=
ETHERSCAN_KEY=
POLYGONSCAN_KEY=
PRIVATE_KEY=
TEST_OWNER_PRIVATE_KEY=
MNEMONIC=

# Always true when running locally or in test
NOT_CI=true
```

5. compile contracts with hardhat
```
yarn hardhat compile
```

6. compile contracts with foundry
```
forge compile
```

7. Run tests using foundry
Used Foundry for testing. I wanted to added tests with Hardhat as well but couldn't do it due to time restrictions.
```
forge test -vv
```

8. Check test coverage
Used Foundry for testing.
```
forge coverage
```

## Deploy contracts
### Setup constants at `./apps/contracts/config/constants.ts`

### Create a new Safe on Goerli testnet.

### Copy the Safe address without the chain pre-fix.

### Replace the address that already exist in `./apps/contracts/config/constants.ts` with the address you got for your new Safe.

### Ensure your address is the one of the owner of the Safe and threshold is only

### Deploy contracts

```
yarn hardhat deploy --network $NETWORK_NAME --tags SignatureAllowance
```

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
```
📦 
├─ .changeset/
├─ .eslintrc.js
├─ .github
│  └─ workflows
│     └─ test.yml
├─ .gitignore
├─ .gitmodules
├─ .npmrc
├─ .yarn/
├─ .yarnrc.yml
├─ README.md
├─ apps
│  └─ contracts
│     ├─ .env.example
│     ├─ .eslintignore
│     ├─ .github/
│     ├─ .gitignore
│     ├─ .gitmodules
│     ├─ .openzeppelin/
│     ├─ CHANGELOG.md
│     ├─ README.md
│     ├─ config
│     │  └─ constants.ts
│     ├─ deploy
│     │  └─ 00_deploy_signature_allowance.ts
│     ├─ deployments/
│     ├─ foundry.toml
│     ├─ hardhat.config.ts
│     ├─ lib/
│     ├─ package.json
│     ├─ remappings.txt
│     ├─ src
│     │  ├─ GM.sol
│     │  ├─ MockToken.sol
│     │  ├─ SafeModule
│     │  │  └─ SafeModule.sol
│     │  ├─ SignatureAllowance
│     │  │  ├─ SignatureAllowance.sol
│     │  │  └─ SignatureAllowanceStorage.sol
│     │  └─ interfaces
│     │     └─ ISignatureAllowance.sol
│     ├─ task
│     │  └─ createNewSignatures.task.ts
│     ├─ test
│     │  ├─ GM.t.sol
│     │  ├─ SignatureAllowance
│     │  │  ├─ SignatureAllowanceExpiryTimeTest.t.sol
│     │  │  ├─ SignatureAllowanceFailSafe.t.sol
│     │  │  ├─ SignatureAllowanceSafeConfigTest.t.sol
│     │  │  ├─ SignatureAllowanceSetup.t.sol
│     │  │  ├─ SignatureAllowanceSignatureValidationTest.t.sol
│     │  │  ├─ SignatureAllowanceTokenAllowlist.t.sol
│     │  │  ├─ SignatureAllowanceUpgradeableTest.t.sol
│     │  │  └─ SignatureAllowanceWithdrawTest.t.sol
│     │  └─ utils
│     │     └─ SetupSafe.s.sol
│     ├─ tsconfig.json
│     └─ typechain-types/
├─ package.json
├─ packages
│  ├─ eslint-config-custom/
│  ├─ tsconfig/
│  └─ utils/
├─ turbo.json
└─ yarn.lock
```

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

