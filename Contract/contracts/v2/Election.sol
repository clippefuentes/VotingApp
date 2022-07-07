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

  function nomitateCandidate(uint256 candidateId) public {
    candidatesRunning.add(candidateId);
  }

  function revokeCandidate(uint256 candidateId) public {
    candidatesRunning.remove(candidateId);
  }

  function candidateRunning() public view returns (uint256[] memory) {
    return candidatesRunning.values();
  }
}