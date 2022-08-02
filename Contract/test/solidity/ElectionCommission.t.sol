// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@std/Test.sol";
import "@std/console.sol";

import { ElectionCommission } from "../../contracts/v2/Proxy/ElectionCommission.sol";

contract ElectionTest is Test {
    ElectionCommission public electioncommision;

    event CreateElection(address indexed _election);
    address public mockNonAdminCaller = address(1);
    function setUp() public {
        electioncommision = new ElectionCommission();
    }

    function testFailCreateElectionIfNonAdmin() public {
        vm.prank(mockNonAdminCaller);
        electioncommision.createElection();
    }

    function testFailNominateCandidateIfSelectedElectionNotExist() public {
        electioncommision.nominateCandidate(1, 1);
    }

    function testNominateCandidate() public {
        electioncommision.createElection();
        electioncommision.nominateCandidate(1, 1);
    }

    // function testExpectEmitCreateElection() public {
    //     uint256 snapshot = vm.createFork("1");
    //     uint currentElectionId = 1;
    //     electioncommision.createElection();
    //     console.log(address(electioncommision.elections(currentElectionId)));
    //     vm.revertTo(snapshot);
    //     console.log(address(electioncommision.elections(currentElectionId)));
        // vm.expectEmit(true, false, false, true);
        // emit CreateElection(address(electioncommision.elections(currentElectionId)));
        // electioncommision.createElection();
    // }
}
