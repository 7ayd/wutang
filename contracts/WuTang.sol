// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

//OpenZeppelin contracts for ERC721. We dont need to write the contracts by hand but we can if we wanted to to make it more efficent if possible i.e. ERC721A.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Wutang Aint Something to F Wtih", "Square") {
        console.log("Enter the Wutang");
    }

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Insane ",
        "Dirty ",
        "Big Baby ",
        "Tha ",
        "B-loved ",
        "E-ratic ",
        "Irate ",
        "Respected ",
        "Cyber ",
        "Crypto ",
        "Thunderous ",
        "Childish ",
        "Ol' "
    ];
    string[] secondWords = [
        "Mastermind",
        "Prodigy",
        "Warrior",
        "Madman",
        "Killah",
        "Swami",
        "Punk",
        "Bastard",
        "Observer",
        "Overlord",
        "Ape",
        "Viking",
        "Mogul"
        "Degen"
    ];

    function pickRandomFirstWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "FIRST_WORD",
                    Strings.toString(block.timestamp)
                )
            )
        );

        rand = rand % firstWords.length;

        return firstWords[rand];
    }

    function pickRandomSecondWord(
        uint256 tokenId
    ) public view returns (string memory) {
        uint256 rand = random(
            string(
                abi.encodePacked(
                    "SECOND_WORD",
                    Strings.toString(block.timestamp)
                )
            )
        );

        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeNFT() public {
        // Grabs the current token ID
        uint256 newItemID = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemID);
        string memory second = pickRandomSecondWord(newItemID);
        string memory combinedWord = string(abi.encodePacked(first, second));

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "Wu-Tang name", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemID);

        _setTokenURI(newItemID, finalTokenUri);

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemID,
            msg.sender
        );

        //Incriments the token ID
        _tokenIds.increment();
    }
}
