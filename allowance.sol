// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    constructor() Ownable(msg.sender) {}

    struct Parent {
        string name;
        address walletAddress;
    }

    struct Kid {
        string name;
        address walletAddress;
    }

    struct Chore {
        string task;
        string description;
        uint256 difficulty;
        bool isCompleted;
    }

    Parent[] public parents;
    Kid[] public kids;
    Chore[] public chores;

    // Function should create a parent. A parent has their name and address associated with them.
    function _createParent(string memory _name, address _walletAddress) public {

    }

    // Function should create a chore. In order to create a chore, it must be created from a parent.
    // A parent has a name and an address. So, the owner of that chore should be assigned from the sender
    function _createChore() public {

    }
}