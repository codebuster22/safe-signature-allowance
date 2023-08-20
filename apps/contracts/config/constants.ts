export const SAFE_ADDRESS = (networkName: string) => {
    switch (networkName) {
		case "goerli":
			return "0xEb1Efa4E11D4abab67A3F5009b9FDaFD59de7dfe";
        default:
            throw Error(`No Safe Deployed on ${networkName}`)
	}
}

export const CONTRACT_NAMES = {
  SIGNATURE_ALLOWANCE: "SignatureAllowance",
  GM: "GM",
  MOCK_TOKEN: "MockToken",
  CONTRACT_CHECKER: "ContractChecker",
  SAFE: "Safe"
}

export const expiryPeriod = 60 * 60 // 1 hour