// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./address_type.sol";

contract party1 {
    address public voter;
    address[] public voter_list_party1;

    constructor(address _voter) {
        voter = _voter;
        voter_list_party1.push(voter);
    }
}

contract party2 {
    address public voter;
    address[] public voter_list_party2;

    constructor(address _voter) {
        voter = _voter;
        voter_list_party2.push(voter);
    }
}

contract vote {
    // Arrays to store voter addresses and deployed contract addresses
    address[] public voterAddressesParty1; // Stores all voter addresses for party1
    address[] public deployedParty1Contracts; // Stores contract addresses that are deployed for party1

    address[] public voterAddressesParty2; // Stores all voter addresses for party2
    address[] public deployedParty2Contracts; // Stores contract addresses that are deployed for party2

    mapping(address => bool) public hasVoted; // Tracks if a voter has voted
    bool public voting = true; // Voting status


    address Election_commsionor=msg.sender;


    // Toggle voting status can be done by election comissionor only.
    function toggleVoting(bool _status) public {
        require( Election_commsionor == msg.sender , "Permission denied can only done by Election Commisnor.");
        voting = _status;
    }

    // Generate a deterministic address for a voter using `address_type` bytecode
    function get_Voter_address(uint256 aadhar) public view returns (address voter_add) {
        require(voting, "Voting is closed now");
        require(aadhar >= 10**11 && aadhar < 10**12, "Invalid Aadhar number: must be 12 digits");//only to check so that aadhar should be of 12 digits :)

        bytes32 salt = keccak256(abi.encodePacked(aadhar));
        bytes memory bytecode = type(address_type).creationCode;

        voter_add = address(
            uint160(uint256(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(bytecode)
            ))))
        );
        return voter_add;
    }

    // Allow a voter to vote for party1
    function voteParty1(address _voter_add) public {
        require(voting, "Voting is closed now");
        require(!hasVoted[_voter_add], "Voter has already voted");

        // Deploy the party1 contract for the voter
        party1 newParty1 = new party1(_voter_add);

        // Store voter address and contract address
        voterAddressesParty1.push(_voter_add); // Add voter address to the voter array
        deployedParty1Contracts.push(address(newParty1)); // Add deployed contract address

        // Mark the voter as having voted
        hasVoted[_voter_add] = true;
    }

    // Allow a voter to vote for party2
    function voteParty2(address _voter_add) public {
        require(voting, "Voting is closed now");
        require(!hasVoted[_voter_add], "Voter has already voted");

        // Deploy the party2 contract for the voter
        party2 newParty2 = new party2(_voter_add);

        // Store voter address and contract address
        voterAddressesParty2.push(_voter_add); // Add voter address to the voter array
        deployedParty2Contracts.push(address(newParty2)); // Add deployed contract address

        // Mark the voter as having voted
        hasVoted[_voter_add] = true;
    }

    // Retrieve all voter addresses for party1
    function getAllVoterAddressesParty1() public view returns (address[] memory) {
        return voterAddressesParty1;
    }

    // Retrieve all deployed contract addresses for party1
    function getAllDeployedContractsParty1() public view returns (address[] memory) {
        return deployedParty1Contracts;
    }

    // Retrieve all voter addresses for party2
    function getAllVoterAddressesParty2() public view returns (address[] memory) {
        return voterAddressesParty2;
    }

    // Retrieve all deployed contract addresses for party2
    function getAllDeployedContractsParty2() public view returns (address[] memory) {
        return deployedParty2Contracts;
    }

    function vote_count_party1() public view returns(uint x){
        x = voterAddressesParty1.length ; 
    }

    function vote_count_party2() public view returns(uint x){
        x = voterAddressesParty2.length ; 
    }

    function winner()public view returns(string memory _winner ){
        require(!voting,"Voting is still going on");
        require(Election_commsionor == msg.sender,"you dont have Permission to do this action");
        uint x1 = vote_count_party1();
        uint x2 = vote_count_party2();

        if(x1>x2){
            return("Winner Is Party 1...!!!Congratulations");

        }
        else{
            return("Winner Is Party 2...!!!Congratulations");
        }
    }
}