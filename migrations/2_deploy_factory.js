const TOKEN = artifacts.require('UCToken');
const CONFIG = require('../config.json');

module.exports = async function (deployer) {
	await deployer.deploy(TOKEN, CONFIG.treasory);
};