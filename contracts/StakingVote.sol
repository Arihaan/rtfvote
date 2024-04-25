// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract StakingVote is Ownable(msg.sender) {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Venue {
        string name;
        string url;
        uint256 votes;
    }

    Venue[] public venues;
    mapping(address => uint256) public lockedFunds;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public voteIndex;
    EnumerableSet.AddressSet private stakers;

    uint256 public votingEndTime;
    uint256 public amountToLock;

    event Vote(address indexed voter, uint256 venueIndex, uint256 amountLocked);
    event VotingEnded();
    event FundsReturned(address indexed staker, uint256 amount);
    event FundsWithdrawn(address indexed staker, uint256 amount);

    constructor(
        string memory venue1Name,
        string memory venue1Url,
        string memory venue2Name,
        string memory venue2Url,
        uint256 _votingDuration,
        uint256 _amountToLock
    ) {
        venues.push(Venue(venue1Name, venue1Url, 0));
        venues.push(Venue(venue2Name, venue2Url, 0));

        votingEndTime = block.timestamp + _votingDuration;
        amountToLock = _amountToLock;
    }

    function vote(uint256 venueIndex) external payable {
        require(block.timestamp < votingEndTime, "Voting has ended");
        require(!hasVoted[msg.sender], "You have already voted");
        require(msg.value >= amountToLock, "Insufficient funds locked");

        hasVoted[msg.sender] = true;
        voteIndex[msg.sender] = venueIndex;
        venues[venueIndex].votes++;
        lockedFunds[msg.sender] += amountToLock;

        stakers.add(msg.sender); // Add the sender to stakers
        emit Vote(msg.sender, venueIndex, amountToLock);
    }

    function endVoting() external onlyOwner {
        require(block.timestamp >= votingEndTime, "Voting is still ongoing");

        emit VotingEnded();
    }

    function withdrawLockedFunds() external {
        uint256 amount = lockedFunds[msg.sender];
        require(amount > 0, "No locked funds to withdraw");

        if (hasVoted[msg.sender]) {
            hasVoted[msg.sender] = false;
        }

        lockedFunds[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit FundsWithdrawn(msg.sender, amount);
    }

    function returnAllFunds() external onlyOwner {
        for (uint256 i = 0; i < stakers.length(); i++) {
            address staker = stakers.at(i);
            uint256 amount = lockedFunds[staker];
            if (amount > 0) {
                if (hasVoted[staker]) {
                    hasVoted[staker] = false;
                }

                lockedFunds[staker] = 0;
                payable(staker).transfer(amount);
                emit FundsReturned(staker, amount);
            }
        }
        // Reset the stakers set by removing all elements
        while (stakers.length() > 0) {
            stakers.remove(stakers.at(0));
        }
    }

    function getVenueVotes() external view returns (uint256, uint256) {
        return (venues[0].votes, venues[1].votes);
    }

    function getRemainingTime() external view returns (uint256) {
        if (block.timestamp < votingEndTime) {
            return votingEndTime - block.timestamp;
        } else {
            return 0;
        }
    }

}
