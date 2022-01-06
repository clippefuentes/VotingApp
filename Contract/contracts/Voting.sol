// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Voting {
  struct Candidate {
    string name;
    string descUrl;
    string picUrl;
    uint votes;
  }
  mapping(address => bool) public hasVoted;
  Candidate[] public candidates;
  Candidate public winner;
  bool public electionStarted;
  bool public electionEnded;
  address public commissioner;

  constructor(
    string[] memory names,
    string[] memory descUrls,
    string[] memory picUrls
  ) public {

    for (uint i = 0; i < names.length; i++) {
      Candidate memory candidate = Candidate({
        name: names[i],
        descUrl: descUrls[i],
        picUrl: picUrls[i],
        votes: 0
      });
      candidates.push(candidate);
    }
    commissioner = msg.sender;
  }

  modifier hasNotVoted {
    require(!hasVoted[msg.sender]);
    _;
  }

  modifier isCommissioner {
    require(msg.sender == commissioner);
    _;
  }
  
  function getCandidates() public view returns (Candidate[] memory) {
    return candidates;
  }

  function getCandidate(uint index) public view returns (Candidate memory) {
    return candidates[index];
  }

  function voteCandidate(uint index) external hasNotVoted {
    require(electionStarted && !electionEnded);
    candidates[index].votes++;
    hasVoted[msg.sender] = true;
  }

  function getHasVoted() public view returns (bool) {
    return hasVoted[msg.sender];
  }

  function startElection() external isCommissioner {
    require(!electionStarted && !electionEnded);
    electionStarted = true;
    assert(electionStarted);
  }

  function endElection() external isCommissioner {
    require(electionStarted && !electionEnded);
    electionEnded = true;
    setWinner();
  }

  function setWinner() private {
    require(electionEnded);
    uint winnerIndex = 0;
    uint winnerVotes = 0;
    for (uint i = 0; i < candidates.length; i++) {
      if (candidates[i].votes > winnerVotes) {
        winnerIndex = i;
        winnerVotes = candidates[i].votes;
      }
    }
    winner = candidates[winnerIndex];
  }
  
}