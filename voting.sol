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
   // address[] public voterAddressesParty1; // Stores all voter addresses for party1... not needed now as can be accesed by deployed contract address
    address[] public deployedParty1Contracts; // Stores contract addresses that are deployed for party1

   //address[] public voterAddressesParty2; // Stores all voter addresses for party2 ...not needed now as can be accesed by deployed contract address
    address[] public deployedParty2Contracts; // Stores contract addresses that are deployed for party2

    mapping(address => bool) public hasVoted; // Tracks if a voter has voted
    bool public voting = false; // Voting status intially voting is stopped...

  


    //here authorities refers to person jiske saamne sab process hogi
    //like candidate of both party,pooling officer,sp and Collector...to maintain a trustworthy process..
    address[] public authorities;
    mapping (address => bool) isSigned;
    
    constructor(address[] memory _owners){
        require(_owners.length>1,"Not Enough Autohrities");
        for(uint i=0;i<_owners.length;i++){
            require(_owners[i]!=address(0),"Invalid authority Address given");
            authorities.push(_owners[i]);
        }
    }

    function toVerify(string memory _purpose) public {
        require(!isSigned[msg.sender], "already verified.");
        isSigned[msg.sender]=true;
        
    }



    function has_All_Verified() public view returns (bool) {
        uint sign_count=0;
        for(uint i=0;i<authorities.length;i++){
           if (isSigned[authorities[i]]==true) {sign_count+=1;} // sign count will be incremented only when authority is verified by election commisionor and not by anybody else :)
        }

        if(sign_count==authorities.length) return true;
        else return false;


    }








    // Toggle voting status can be done by election comissionor only.
    function toggleVoting(bool _status) public {
        require( has_All_Verified() , "Permission denied, Should verified by All Members.");
        voting = _status;

        //now again assinging value=false to isSigned map so that it can be reset..
        for(uint i=0;i<authorities.length;i++){
            isSigned[authorities[i]]=false;
        }
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
       // voterAddressesParty1.push(_voter_add); // Add voter address to the voter array
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
        //voterAddressesParty2.push(_voter_add); // Add voter address to the voter array
        deployedParty2Contracts.push(address(newParty2)); // Add deployed contract address

        // Mark the voter as having voted
        hasVoted[_voter_add] = true;
    }

    // Retrieve all voter addresses for party1
    //function getAllVoterAddressesParty1() public view returns (address[] memory) {
      //  return voterAddressesParty1;
    //}

    // Retrieve all deployed contract addresses for party1
    function getAllDeployedContractsParty1() public view returns (address[] memory) {
        return deployedParty1Contracts;
    }

    // Retrieve all voter addresses for party2
    // instead of this can use deployed address to access this
    //function getAllVoterAddressesParty2() public view returns (address[] memory) {
    //     return voterAddressesParty2;
    // }

    ///
    // Retrieve all deployed contract addresses for party1
    function getVoterFromParty1Contract(address partyAddress) public view returns (address) {
    party1 p = party1(partyAddress); // or party2 depending on the contract
    return p.voter();
}



    // Retrieve all deployed contract addresses for party1
    function getVoterFromParty2Contract(address partyAddress) public view returns (address) {
    party2 p = party2(partyAddress); // or party2 depending on the contract
    return p.voter();
}


    // Retrieve all deployed contract addresses for party2
    function getAllDeployedContractsParty2() public view returns (address[] memory) {
        return deployedParty2Contracts;
    }



    function vote_count_party1() public view returns(uint x){
        x = deployedParty1Contracts.length ; 
    }

    function vote_count_party2() public view returns(uint x){
        x = deployedParty2Contracts.length ; 
    }

  function winner() public  returns (string memory _winner) {
    require(!voting, "Voting is still going on");
    require(has_All_Verified(), "Permission denied: Should be verified by All Members");

    // Reset `isSigned` for future processes
    for (uint i = 0; i < authorities.length; i++) {
        isSigned[authorities[i]] = false;
    }

    uint x1 = vote_count_party1();
    uint x2 = vote_count_party2();

    if (x1 > x2) {
        _winner = "Winner Is Party 1...!!! Congratulations";
    } else if (x2 > x1) {
        _winner = "Winner Is Party 2...!!! Congratulations";
    } else {
        _winner = "There is a tie in the Election. Re-Election will be Held. Dates will be Announced shortly.";
    }

    return _winner; // Explicit return statement
}

}
