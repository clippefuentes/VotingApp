// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@std/Test.sol";
import { Election } from "../../contracts/v2/Election.sol";
import { ElectionStatus } from "../../contracts/v2/interface/IElection.sol";

contract ElectionTest is Test {
    Election public election;
    address public voter1 = address(1);
    function setUp() public {
        election = new Election(msg.sender);
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

    function testElectionElectionStatus() public {
        assert(election.status() == ElectionStatus.NOMINATION);
        election.nominateCandidate(1);
        election.nominateCandidate(2);
        election.startElection();
        assert(election.status() == ElectionStatus.ELECTION);
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
        election.nominateCandidate(1);
        election.nominateCandidate(2);
        election.startElection();
    }

    function testFailStartElectionStatusIsNotNomination() public {
        election.startElection();
        election.startElection();
    }

    // endElection
    function testFailEndElectionIfIsElectionTimeNotEnded() public {
        election.startElection();
        election.endElection();
    }

    function testExpectRevertStartElectionIfNoCandidates() public {
        vm.expectRevert(abi.encodePacked("Election: Election must have two candidates to start"));
        election.startElection();
    }

    function testFailEndElectionCallByNonAdmin() public {
        election.startElection();
        vm.prank(voter1);
        election.endElection();
    }

    function testElectionFlow() public {
        election.nominateCandidate(5);
        election.nominateCandidate(10);
        vm.deal(voter1, .5 ether);
        vm.deal(address(2), .5 ether);
        vm.prank(voter1);
        election.registerVoter{value: 0.5 ether}();
        vm.prank(address(2));
        election.registerVoter{value: 0.5 ether}();
        election.startElection();
        vm.prank(voter1);
        election.voteCandidate(5);
        vm.prank(address(2));
        election.voteCandidate(5);
        vm.warp(1 days + 1 seconds);
        election.endElection();
        uint electionCandidateWinterId = election.winnerID();
        uint electionCandidateWinterVotes = election.winnerVotes();
        assertEq(electionCandidateWinterId, 5);
        assertEq(electionCandidateWinterVotes, 2);
    }

}
