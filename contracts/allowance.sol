// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Allowance is Ownable {
    using Strings for uint256;

    uint256 idDigits = 3;
    uint256 idModulus = 10 ** idDigits;

    event LogParentId(string);

    struct Parent {
        string name;
        address walletAddress;
        uint256 id;
    }

    struct Kid {
        string name;
        address walletAddress;
        uint256 id;
    }

    struct Chore {
        string task;
        string description;
        uint256 difficulty;
        Kid kidAssigned;
        bool isCompleted;
        uint256 id;
    }

    Parent[] public parents;
    Kid[] public kids;
    Chore[] public chores;

    mapping (uint256 => Parent) public mapParent;
    mapping (uint256 => Kid) public mapKid;
    mapping (uint256 => Chore) public mapChore;

    constructor() Ownable(msg.sender) {}

    function _generateRandomId(string memory _str) private view returns(uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % idModulus;
    }

    function _createParent(string memory _name, address _walletAddress) public {
        uint parentId = _generateRandomId(_name);

        Parent memory parent = Parent(_name, _walletAddress, parentId);
        parents.push(parent);
        mapParent[parentId] = parent;

        string memory message = string(abi.encodePacked("Your parent ID: ", parentId.toString(), ". Do not forget!"));

        emit LogParentId(message);
    }

    function _createKid(string memory _name, address _walletAddress, uint256 _parentId) public isParent(_parentId) {
        uint kidId = _generateRandomId(_name);
        Kid memory kid = Kid(_name, _walletAddress, kidId);
        kids.push(kid);
        mapKid[kidId] = kid;
    }

    function _createChore(string memory _task, string memory _description, uint256 _difficulty, uint256 _parentId) public isParent(_parentId) {
        string memory hashed = string(abi.encodePacked(_task, _difficulty.toString(), _parentId.toString()));
        uint choreId = _generateRandomId(hashed);
        Chore memory chore = Chore(
            _task,
            _description,
            _difficulty,
            Kid("", address(0), 0),
            false,
            choreId
        );
        chores.push(chore);
        mapChore[choreId] = chore;
    }

    function _assignChore(uint256 _parentId, uint256 _kidId, uint256 _choreId) public isParent(_parentId) isKid(_kidId) isChore(_choreId) {
        mapChore[_choreId].kidAssigned = mapKid[_kidId];
    }

    modifier isParent(uint256 _parentId) {
        bool hasValidId = bytes(mapParent[_parentId].name).length > 0;
        require(hasValidId, "Given parent ID not present in 'parent' list");
        _;
    }

    modifier isKid(uint256 _kidId) {
        bool hasValidId = bytes(mapKid[_kidId].name).length > 0;
        require(hasValidId, "Given kid ID not present in 'kid' list");
        _;
    }

    modifier isChore(uint256 _choreId) {
        bool hasValidId = bytes(mapChore[_choreId].task).length > 0;
        require(hasValidId, "Given chore ID not present in 'chore' list");
        _;
    }
}