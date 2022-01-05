const Voting = artifacts.require("Voting");

contract('Voting', (accounts) => {
  it('Return correct candidates', async () => {
    const metaCoinInstance = await Voting.deployed();
    const candidates = await metaCoinInstance.getCandidates();
    assert.equal(candidates.length, 3, "candidates length is not 3");
    // assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
});