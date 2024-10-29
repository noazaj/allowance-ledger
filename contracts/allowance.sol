// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Allowance is Ownable {
    using Strings for uint256;

    uint256 idDigits = 5;
    uint256 idModulus = 10 ** idDigits;

    event LogParentId(string);

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

    Parent[] parents;
    Kid[] kids;
    Chore[] public chores;

    mapping (uint256 => Parent) public mapParent;
    mapping (uint256 => Kid) public mapKid;

    constructor() Ownable(msg.sender) {}

    function _generateRandomId(string memory _str) private view returns(uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % idModulus;
    }

    // Function should create a parent. A parent has their name and address associated with them.
    function _createParent(string memory _name, address _walletAddress) public {
        uint parentId = _generateRandomId(_name);

        Parent memory parent = Parent(_name, _walletAddress);
        parents.push(parent);
        mapParent[parentId] = parent;

        string memory message = string(abi.encodePacked("Your parent ID: ", parentId.toString(), ". Do not forget!"));

        emit LogParentId(message);
    }

    function _createKid(string memory _name, address _walletAddress, uint256 _parentId) public isParent(_parentId) {
        uint kidId = _generateRandomId(_name);
        Kid memory kid = Kid(_name, _walletAddress);
        kids.push(kid);
        mapKid[kidId] = kid;
    }

    // Function should create a chore. In order to create a chore, it must be created from a parent.
    // A parent has a name and an address. So, the owner of that chore should be assigned from the sender
    function _createChore() public {

    }

    modifier isParent(uint256 _parentId) {
        bool hasValidId = bytes(mapParent[_parentId].name).length > 0;
        require(hasValidId, "Given parent ID not present in list");
        _;
    }
}