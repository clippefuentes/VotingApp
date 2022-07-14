// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {
  ERC721Enumerable,
  ERC721,
  IERC721
} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { IElection } from "./interface/IElection.sol";


contract ElectionCommission is AccessControl {
  bytes32 public constant ADMIN_ROLE = keccak256("COMMISSION");
  IERC721 internal candidatesContract;
  mapping(uint => bool) internal isOnElection;
  uint256 private electionId = 0;

  constructor(
    IERC721 _candidatesContract
  ) payable {
    _setupRole(ADMIN_ROLE, _msgSender());
    candidatesContract = _candidatesContract;
  }

  function setAdminUser(address _newAdmin) external onlyRole(ADMIN_ROLE) {
    grantRole(ADMIN_ROLE, _newAdmin);
  }
}