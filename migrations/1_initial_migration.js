const MIGRATIONS = artifacts.require('Migrations');

module.exports = function (deployer) {
	deployer.deploy(MIGRATIONS);
};
