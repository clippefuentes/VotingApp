// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {
  EnumerableSetUpgradeable
} from "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import { ERC721Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import { IERC721Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import { AccessControlUpgradeable } from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { IElection, ElectionStatus } from "../interface/IElection.sol";
import { Election } from "../Election.sol";



contract ElectionCommission is Initializable, AccessControlUpgradeable {
  using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
  EnumerableSetUpgradeable.UintSet internal electionsIds;
  EnumerableSetUpgradeable.UintSet internal pastElectionsIds;
  bytes32 public constant ADMIN_ROLE = keccak256("COMMISSION");
  IERC721Upgradeable internal candidatesContract;
  mapping(uint => bool) internal isOnElection;
  // Starting from 1
  uint256 private electionId = 1;
  mapping(uint => Election) public elections;

  event CreateElection(address indexed _election);

  // constructor(
  //   // IERC721 _candidatesContract
  // ) payable {
  //   _setupRole(ADMIN_ROLE, _msgSender());
  //   // candidatesContract = _candidatesContract;
  // }

  function initialize(
    // IERC721 _candidatesContract
  ) public initializer {
    _setupRole(ADMIN_ROLE, _msgSender());
    // candidatesContract = _candidatesContract;
  }

  function setAdminUser(address _newAdmin) external onlyRole(ADMIN_ROLE) {
    grantRole(ADMIN_ROLE, _newAdmin);
  }

  function createElection() external onlyRole(ADMIN_ROLE) {
    Election election = new Election(msg.sender);
    elections[electionId] = election;
    electionsIds.add(electionId);
    electionId++;
    
    emit CreateElection(address(election));
  }

  function nominateCandidate(uint _candidateId, uint _electionId) external onlyRole(ADMIN_ROLE) {
    require(!isOnElection[_candidateId], "ElectionCommission: Candidate is on election");
    Election election = elections[_electionId];
    require(election.status() == ElectionStatus.NOMINATION, "ElectionCommission: Is not in nomination mode");
    require(election.endDate() == 0, "ElectionCommission: candidate cant backout");
    require(address(election) != address(0), "ElectionCommissioner: Election not existing");
    election.nominateCandidate(_candidateId);
    isOnElection[_candidateId] = true;
  }

  function revokeCandidate(uint _candidateId, uint _electionId) external onlyRole(ADMIN_ROLE) {
    require(isOnElection[_candidateId], "ElectionCommission: Candidate is not on election");
    Election election = elections[_electionId];
    require(election.status() == ElectionStatus.NOMINATION, "ElectionCommission: Is not in nomination mode");
    require(
      election.endDate() == 0, 
      "ElectionCommission: candidate cant backout"
    );
    require(address(election) != address(0), "ElectionCommissioner: Election not existing");
    election.revokeCandidate(_candidateId);
    isOnElection[_candidateId] = false;
  }

  function conceedCandidate(uint _candidateId, uint _electionId) external onlyRole(ADMIN_ROLE) {
    require(isOnElection[_candidateId], "ElectionCommission: Candidate is not on election");
    Election election = elections[_electionId];
    require(election.status() == ElectionStatus.END, "ElectionCommission: Election still ongoing");
    require(address(election) != address(0), "ElectionCommissioner: Election not existing");
    require(
      block.timestamp >= election.endDate(), 
      "ElectionCommission: Election not ended"
    );
    election.revokeCandidate(_candidateId);
    isOnElection[_candidateId] = false;
  }

  function endElection(uint _electionId) external onlyRole(ADMIN_ROLE) {
    Election election = elections[_electionId];
    election.endElection();
    electionsIds.remove(_electionId);
    pastElectionsIds.add(_electionId);
  }
}