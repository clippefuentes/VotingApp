// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

enum ElectionStatus {
  NOMINATION,
  ELECTION,
  END
}

interface IElection {
  function registerVoter() external payable;

  function startElection() external;
}