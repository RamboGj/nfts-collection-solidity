// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyNFTCollection is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event newNftMinted(address sender, uint256 tokenId);


    uint256 MAX_AMOUNT = 50;
    uint256 private NftsMinted;

    constructor() ERC721 ("myNft", "MNFT") {
        console.log("Contrato NFT feito");
    }

    function getNumberOfNftMinted() public view returns (uint256) {
        return NftsMinted;
    }

    function makeAnNFT() public {
        // pega o tokenId atual, começando de 0. Para cada mint, é um nft com tokenId diferente
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= MAX_AMOUNT, "All NFTs were minted");

        // Mina o NFT para o msg.sender(quem chamou o contrato) e recebe o id do token(newItemId)
        _safeMint(msg.sender, newItemId);

        // atribui um dado do NFT
        _setTokenURI(newItemId, "ipfs://QmcHns4umbQGXZB6NApZRr4rt9AKdKRnhm8cnqBAAH39f1");
        console.log("NFT com ID %s foi mintado para %s", newItemId, msg.sender);

        // incrementa o Id para o próximo ser diferente desse no próximo mint
        _tokenIds.increment();

        NftsMinted = _tokenIds.current();

        emit newNftMinted(msg.sender, newItemId);
    }
}