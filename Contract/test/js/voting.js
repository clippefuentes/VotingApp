const Voting = artifacts.require("Voting");

contract('Voting', (accounts) => {
  it('Return correct candidates', async () => {
    const votingInstance = await Voting.deployed();
    const candidates = await votingInstance.getCandidates();
    assert.equal(candidates.length, 4, "candidates length is not 4");
    // assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });

  it('Check if user can vote and not vote if election is not started, check if it returns correct number of votes', async() => {
    const votingInstance = await Voting.deployed();
    const [user1, user2, user3] = accounts;
    const hasVoted = await votingInstance.hasVoted.call(user2);
    assert.equal(hasVoted, false, "current user is noted voted yed");
    try {
      await votingInstance.voteCandidate(1, {from: user2});
    } catch(err) {
      assert(err, "Voting was not reverted");
    }

    const electionStarted1 = await votingInstance.electionStarted.call();
    assert.equal(electionStarted1, false, "Election is not started");
    await votingInstance.startElection({ from: user1 });
    const electionStarted2 = await votingInstance.electionStarted.call();
    assert.equal(electionStarted2, true, "Election is started");
    await votingInstance.voteCandidate(1, { from: user2 });
    const voted1 = await votingInstance.hasVoted.call(user2);
    await assert.equal(voted1, true, "User has not voted");
    let candidate1 = await votingInstance.getCandidate.call(1);
    assert.equal(Number(candidate1.votes), 1, "Candidate 1 has not received 1 vote");
    try {
      await votingInstance.voteCandidate(1, { from: user2 });
    } catch (err) {
      assert(err, "Voting was not reverted");
    }
    await votingInstance.voteCandidate(1, { from: user3 });
    candidate1 = await votingInstance.getCandidate.call(1);
    assert(Number(candidate1.votes) === 2, "Candidate 1 has not received 2 votes");
  });

  it ('Set correct candidate', async () => {
    const votingInstance = await Voting.deployed();
    await votingInstance.endElection({ from: accounts[0] });
    const winner = await votingInstance.winner.call();
    assert.equal(winner.name, "Nick", "Winner is not Nick");
    assert.equal(winner.descUrl, "Democratic", "Winner is not Democratic");
    assert.equal(winner.votes.toNumber(), 2, "Winner is not 2 votes");
  })
});