// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

enum ElectionStatus {
  NOMINATION,
  ELECTION,
  END
}
contract Election {
  using EnumerableSet for EnumerableSet.UintSet;
  ElectionStatus public status;
  mapping(uint => uint256) internal votes;
  EnumerableSet.UintSet internal candidatesRunning;

  constructor() {
    status = ElectionStatus.NOMINATION;
  }

  function nominateCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.NOMINATION) {
    candidatesRunning.add(candidateId);
  }

  function revokeCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.NOMINATION) {
    _removeCandidate(candidateId);
  }

  function conceedCandidate(uint256 candidateId) external onlyStatus(ElectionStatus.END) {
    _removeCandidate(candidateId);
  }

  function candidateRunning() public view returns (uint256[] memory) {
    return candidatesRunning.values();
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