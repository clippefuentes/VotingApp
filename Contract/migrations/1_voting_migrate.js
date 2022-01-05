const Voting = artifacts.require("Voting");

module.exports = function(deployer) {
  deployer.deploy(
    Voting,
    ['Rama', 'Nick', 'Jose'],
    ['d1', 'd2', 'd3'],
    ['p1', 'p2', 'p3']
  );
};
