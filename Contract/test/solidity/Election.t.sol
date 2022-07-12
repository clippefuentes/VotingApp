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

    function testFailRegisterVoterNoBalance() public {
        vm.prank(voter1);
        election.registerVoter{value: 0.5 ether}();
    }

    function testFailRegisterVoterNoValue() public {
        vm.prank(voter1);
        vm.deal(voter1, .5 ether);
        election.registerVoter();
    }
    function testRegisterVoter() public {
        vm.prank(voter1);
        vm.deal(voter1, .5 ether);
        election.registerVoter{value: 0.5 ether}();
    }

    function testFailRegisterVoter() public {
        vm.startPrank(voter1);
        election.registerVoter();
        election.registerVoter();
        vm.stopPrank();
    }

    // function testNumberIs42() public {
    //     assertEq(testNumber, 42);
    // }

    // function testFailSubtract43() public {
    //     testNumber -= 43;
    // }

    // function testCannotSubtract43() public {
    //     vm.expectRevert(stdError.arithmeticError);
    //     testNumber -= 43;
    // }

}
