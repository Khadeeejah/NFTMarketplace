require('@nomiclabs/hardhat-ethers')
require('@nomicfoundation/hardhat-chai-matchers')
require('@nomicfoundation/hardhat-toolbox')
const PRIVATE_KEY = ''
module.exports = {
  solidity: {
    version: '0.8.17',
    settings: { optimizer: { enabled: !0, runs: 200 } },
  },
  networks: {
    fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      chainId: 43113,
      accounts: [
        '5e11b9947afb7979d17b149f0ca9b7d209733defeb683a4973dd6fe4841ecd62',
      ],
    },
  },
}
