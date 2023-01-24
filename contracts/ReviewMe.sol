// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error ReviewMe__NotOwner();
error ReviewMe__NotWhitelisted();

// contract interface
interface IWhitelist {
    function whitelist(address user) external returns (bool);
}

contract ReviewMe {
    address private immutable owner;
    mapping(address => RatingProduct) private userToReview;
    address[] private reviewers;
    uint256 public amountOfReviews;

    address WhitelistContractAddress =
        0x30168B3f07E2A2ed0C65776F6E81311b590e91c0;
    IWhitelist whitelistContract = IWhitelist(WhitelistContractAddress);

    struct RatingProduct {
        string opinion;
        uint8 starsNumber;
        bool isReviewed;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert ReviewMe__NotOwner();
        }
        _;
    }

    modifier isWhitelisted() {
        address whitelistContractAddress = WhitelistContractAddress;
        bytes memory data = abi.encodeWithSignature(
            "whitelist(address)",
            msg.sender
        );
        (bool isWhitelisted, ) = address(whitelistContractAddress).call(data);
        require(isWhitelisted, "Sender is not whitelisted");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setReview(
        string memory _opinion,
        uint8 _starsNumber
    ) public isWhitelisted {
        require(
            _starsNumber >= 1 && _starsNumber <= 5,
            "Invalid stars number, should be from 1 to 5"
        );

        if (userToReview[msg.sender].isReviewed) {
            revert("You have already added a review");
        }
        userToReview[msg.sender].opinion = _opinion;
        userToReview[msg.sender].starsNumber = _starsNumber;
        userToReview[msg.sender].isReviewed = true;
        reviewers.push(msg.sender);

        amountOfReviews++;
    }

    function getReviewByIndex(
        uint256 reviewIndex
    ) public view returns (string memory, uint8) {
        require(reviewIndex < reviewers.length, "Invalid index");

        return (
            userToReview[reviewers[reviewIndex]].opinion,
            userToReview[reviewers[reviewIndex]].starsNumber
        );
    }
}
