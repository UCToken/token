const hdWalletProvider = require('@truffle/hdwallet-provider');
const CONFIG = require('./config.json');

module.exports = {
	networks: {
		live: {
			provider: () => new hdWalletProvider(CONFIG.mnemonic, " https://bsc-dataseed.binance.org/"),
			network_id: "56",
			confirmations: 2,
			timeoutBlocks: 200,
			skipDryRun: true
		},
		local: {
			host: "127.0.0.1",
			port: 8545,           
			network_id: "5777"   
		}
	},
	compilers: {
		solc: {
			version: "0.8.14"
		}
	},
	plugins: ['truffle-plugin-verify'],
	api_keys: {
		bscscan: CONFIG.verify_apikey
	}
};
