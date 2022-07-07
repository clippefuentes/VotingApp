// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@std/Test.sol";

contract ContractTest is Test {
    uint256 public testNumber;
    function setUp() public {
        testNumber = 42;
    }

    function testExample() public {
        uint a = 1;
        uint b = 1;
        assertTrue(true);
        assertEq(a, b);
    }

    function testNumberIs42() public {
        assertEq(testNumber, 42);
    }

    function testFailSubtract43() public {
        testNumber -= 43;
    }

    function testCannotSubtract43() public {
        vm.expectRevert(stdError.arithmeticError);
        testNumber -= 43;
    }

}
