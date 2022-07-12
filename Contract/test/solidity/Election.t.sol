// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@std/Test.sol";
import { Election } from "../../contracts/v2/Election.sol";

contract ElectionTest is Test {
    Election public election;
    address public voter1 = address(1);
    function setUp() public {
        election = new Election();
    }

    // registerVoter
    function testFailRegisterVoterNoBalance() public {
        vm.prank(voter1);
        election.registerVoter{value: 0.5 ether}();
    }

    function testFailRegisterVoterNoValue() public {
        vm.deal(voter1, .5 ether);
        vm.prank(voter1);
        election.registerVoter();
    }
    function testRegisterVoter() public {
        vm.deal(voter1, .5 ether);
        vm.prank(voter1);
        election.registerVoter{value: 0.5 ether}();
    }

    function testFailRegisterVoterTwice() public {
        vm.deal(voter1, 1 ether);
        vm.startPrank(voter1);
        election.registerVoter{value: 0.5 ether}();
        election.registerVoter{value: 0.5 ether}();
        vm.stopPrank();
    }

    function testFailRegisterVoterIfElection() public {
        election.startElection();
        vm.deal(voter1, 1 ether);
        vm.prank(voter1);
        election.registerVoter{value: 0.5 ether}();
    }

    // startElection

    function testFailStartElectionIfNotAdmin() public {
        vm.prank(voter1);
        election.startElection();
    }

    function testStartElectionAdmin() public {
        election.startElection();
    }

    function testFailStartElectionStatusIsNotNomination() public {
        election.startElection();
        election.startElection();
    }
}
