/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

module.exports = {
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    },
    networks: {
/*
        rinkeby: {
            provider: provider,
            network_id: 4, // eslint-disable-line camelcase
            gasPrice: "7000000000",
            gas: 6000000,
        },
        main: {
            provider: providerMain,
            network_id: 1, // eslint-disable-line camelcase
            gasPrice: "1000000000",
            gas: 6000000,
        },
		*/
        testrpc: {
            host: 'localhost',
            port: 8545,
            gasPrice: 0x01,
            network_id: '*', // eslint-disable-line camelcase
        },
        ganache: {
            host: 'localhost',
            port: 8545,
            network_id: '*', // eslint-disable-line camelcase
            gas: 6000000
        },
        local: {
            host: 'localhost',
            port: 9545,
            network_id: '*', // eslint-disable-line camelcase
            gasPrice: 6000000
        },
    }
};
