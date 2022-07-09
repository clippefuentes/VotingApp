// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { ElectionStatus } from "./interface/IElection.sol";

contract Election is AccessControl {
  using EnumerableSet for EnumerableSet.UintSet;
  ElectionStatus public status;
  mapping(uint256 => uint256) public votes;
  EnumerableSet.UintSet internal candidatesRunning;
  mapping(address => bool) internal registeredVoter;
  mapping(address => bool) internal hasVote;
  uint private registerFee  = 0.5 ether;
  uint private endDate;

  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");

  // The ElectionComission and the admin user from electionCommission is the initial commissioner of this election
  constructor(address altCommisioner) {
    status = ElectionStatus.NOMINATION;
    _setupRole(ADMIN_ROLE, _msgSender());
    _setupRole(ADMIN_ROLE, altCommisioner);
  }

  // Election Function

  /**
    Before voting user must register, in V2 we only register when user sends registerFee to register
    PLAN next v3: in v3 will add erc20 token instead of ether
  */ 
  function registerVoter() external payable onlyStatus(ElectionStatus.NOMINATION)  {
    require(msg.value <= registerFee, "Election: Must pay for registration");
    registeredVoter[msg.sender] = true;
  }

  /**
    Start election, only ElectionCommitioner can start election
  */
  function startElection() external onlyStatus(ElectionStatus.NOMINATION) onlyRole(ADMIN_ROLE)  {
    status = ElectionStatus.ELECTION;
    endDate = block.timestamp + 1 days;
  }

  function endElection() external onlyStatus(ElectionStatus.ELECTION) onlyRole(ADMIN_ROLE) electionTimeEnded {
    status = ElectionStatus.END;
  }

  // Candidate Function

  function nominateCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.NOMINATION) onlyRole(ADMIN_ROLE) {
    require(!isCandidateOnThisElection(candidateId), "Election: Already in this election");
    candidatesRunning.add(candidateId);
  }

  function revokeCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.NOMINATION) onlyRole(ADMIN_ROLE) {
    require(isCandidateOnThisElection(candidateId), "Election: in not in this election");
    _removeCandidate(candidateId);
  }

  function conceedCandidate(
    uint256 candidateId
  )
    external
    onlyStatus(ElectionStatus.END)
    onlyRole(ADMIN_ROLE)
    electionTimeEnded 
  {
    require(isCandidateOnThisElection(candidateId), "Election: in not in this election");
    _removeCandidate(candidateId);
  }

  function voteCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.ELECTION) onGoingElection {
    require(isCandidateOnThisElection(candidateId), "Election: Candidate is not on this election");
    require(!hasVote[msg.sender], "Election: Has already voted");
    require(registeredVoter[msg.sender], "Election: Has not registered this election");
    votes[candidateId]++;
    hasVote[msg.sender] = true;
  }

  function setRole(address newCommissioner) external onlyRole(ADMIN_ROLE) {
    _setupRole(ADMIN_ROLE, newCommissioner);
  }

  // Getters
  function candidateRunning() public view returns (uint256[] memory) {
    return candidatesRunning.values();
  }

  function isCandidateOnThisElection(uint256 candidate) public view returns (bool) {
    return candidatesRunning.contains(candidate);
  }

  // -------------- Private
  function _removeCandidate(uint256 candidateId) private onlyStatus(ElectionStatus.END) {
    candidatesRunning.remove(candidateId);
  }

  // Modifier
  modifier onlyStatus(ElectionStatus _status) {
    require(status == _status, "Election: Not following status");
    _;
  }

  modifier onGoingElection() {
    require(block.timestamp < endDate, "Election: Election time has ended");
    _;
  }

  modifier electionTimeEnded() {
    require(block.timestamp >= endDate, "Election: Election time has ended");
    _;
  }
}