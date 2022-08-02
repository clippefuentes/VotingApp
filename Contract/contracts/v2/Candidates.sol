// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import { AccessControlUpgradeable } from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { Position, Candidate } from "./interface/ICandidates.sol";

contract Candidates is AccessControlUpgradeable, ERC721EnumerableUpgradeable   {
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER");
  uint256 public nextId  = 0;
  mapping(uint => Candidate) public candidates;

  //  constructor() ERC721("Candidate", "Cand") {
  //   _setupRole(ADMIN_ROLE, _msgSender());
  //   _setupRole(MINTER_ROLE, _msgSender());
  //   _safeMint(address(this), 0);
  //  }

  function initialize() initializer public {
    __ERC721_init("Candidate", "Cand");
    _setupRole(ADMIN_ROLE, _msgSender());
    _setupRole(MINTER_ROLE, _msgSender());
    _safeMint(address(this), 0);
  }

   function mintCandidate(
    string memory name,
    uint8 position,
    string memory family
   ) external onlyRole(MINTER_ROLE) {
      Candidate memory candidate = Candidate({
        name: name,
        position: selectPosition(position),
        family: family
      });
      candidates[nextId] = candidate;
      _safeMint(msg.sender, nextId);
      nextId++;
   }

   function _baseURI() internal pure override returns (string memory) {
       return "https://opensea-creatures-api.herokuapp.com/api/creature/";
   }

  // Helper function

  function selectPosition(uint8 position) internal pure returns (Position pos) {
      require(position > 0 && position <= 4, "Candidate: Position not exist and out of bounds");
      if (position == 1) {
        pos = Position.PRESIDENT;
      } else if (position == 2) {
        pos = Position.VICE_PRESIDENT;
      } else if (position == 3) {
        pos = Position.GOVERNOR;
      } else if (position == 4) {
        pos = Position.MAYOR;
      }
      return pos;
  }
  // -------- Modifier

  // Override
  function supportsInterface(bytes4 interfaceId) public view override(AccessControlUpgradeable, ERC721EnumerableUpgradeable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
} 