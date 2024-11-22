package chainconfig

import (
	interchaintest "github.com/strangelove-ventures/interchaintest/v8"
	"github.com/strangelove-ventures/interchaintest/v8/ibc"
)

var DefaultChainSpecs = []*interchaintest.ChainSpec{
	// -- IBC-Go --
	{
		ChainConfig: ibc.ChainConfig{
			Type:    "cosmos",
			Name:    "ibc-go-simd",
			ChainID: "simd-1",
			Images: []ibc.DockerImage{
				{
<<<<<<< HEAD
					Repository: "ghcr.io/cosmos/ibc-go-wasm-simd",  // FOR LOCAL IMAGE USE: Docker Image Name
					Version:    "gjermund-7591-ics20-abi-encoding", // FOR LOCAL IMAGE USE: Docker Image Tag
=======
					Repository: "ghcr.io/cosmos/ibc-go-wasm-simd", // FOR LOCAL IMAGE USE: Docker Image Name
					Version:    "gjermund-abi-test",               // FOR LOCAL IMAGE USE: Docker Image Tag
>>>>>>> 569bb1c (fixtures and update benchmark)
					UidGid:     "1025:1025",
				},
			},
			Bin:            "simd",
			Bech32Prefix:   "cosmos",
			Denom:          "stake",
			GasPrices:      "0.00stake",
			GasAdjustment:  1.3,
			EncodingConfig: CosmosEncodingConfig(),
			ModifyGenesis:  defaultModifyGenesis(),
			TrustingPeriod: "508h",
			NoHostMount:    false,
		},
	},
}
