// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

enum Position {
  PRESIDENT,
  VICE_PRESIDENT,
  GOVERNOR,
  MAYOR
}

struct Candidate {
  string name;
  Position position;
  string family;
}
