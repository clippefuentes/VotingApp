// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { ElectionStatus } from "./interface/IElection.sol";

contract Election {
  using EnumerableSet for EnumerableSet.UintSet;
  ElectionStatus public status;
  mapping(uint256 => uint256) public votes;
  EnumerableSet.UintSet internal candidatesRunning;
  mapping(address => bool) internal registeredVoter;
  mapping(address => bool) internal hasVote;
  uint private registerFee  = 0.5 ether;

  constructor() {
    status = ElectionStatus.NOMINATION;
  }

  /**
    Before voting user must register, in V2 we only register when user sends registerFee to register
    PLAN next v3: in v3 will add erc20 token instead of ether
  */ 
  function registerVoter() external payable {
    require(msg.value <= registerFee, "Election: Must pay for registration");
    registeredVoter[msg.sender] = true;
  }

  /**
    Before voting user must register, in V2 we only register when user sends registerFee to register
    PLAN next v3: in v3 will add erc20 token instead of ether
  */

  // Election Function
  function startElection() external onlyStatus(ElectionStatus.NOMINATION) {
    status = ElectionStatus.ELECTION;
  }

  // Candidate Function

  function nominateCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.NOMINATION) {
    require(!isCandidateOnThisElection(candidateId), "Election: Already in this election");
    candidatesRunning.add(candidateId);
  }

  function revokeCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.NOMINATION) {
    require(isCandidateOnThisElection(candidateId), "Election: in not in this election");
    _removeCandidate(candidateId);
  }

  function conceedCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.END) {
    require(isCandidateOnThisElection(candidateId), "Election: in not in this election");
    _removeCandidate(candidateId);
  }

  function voteCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.ELECTION) {
    require(isCandidateOnThisElection(candidateId), "Election: Candidate is not on this election");
    require(!hasVote[msg.sender], "Election: Has already voted");
    require(registeredVoter[msg.sender], "Election: Has not registered this election");
    votes[candidateId]++;
    hasVote[msg.sender] = true;
  }

  // Getters
  function candidateRunning() public view returns (uint256[] memory) {
    return candidatesRunning.values();
  }

  function isCandidateOnThisElection(uint256 candidate) public view returns (bool) {
    return candidatesRunning.contains(candidate);
  }

  // --------------
  function _removeCandidate(uint256 candidateId) private onlyStatus(ElectionStatus.END) {
    candidatesRunning.remove(candidateId);
  }

  // Modifier
  modifier onlyStatus(ElectionStatus _status) {
    require(status == _status, "Election: Not following status");
    _;
  }
}