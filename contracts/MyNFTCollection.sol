// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyNFTCollection is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg  xmlns='http://www.w3.org/2000/svg'  preserveAspectRatio='xMinYMin meet'  viewBox='0 0 350 350'>  <defs>    <linearGradient id='Gradient1'>      <stop class='stop1' offset='0%'/>      <stop class='stop2' offset='50%'/>      <stop class='stop3' offset='100%'/>    </linearGradient>  </defs>  <style>    .base {      fill: blue;      font-family: serif;      font-size: 20px;      color: #FFF;    }    .stop1 { stop-color: green; }    .stop2 { stop-color: white; stop-opacity: 0; }    .stop3 { stop-color: yellow; }      </style>  <rect width='100%' height='100%' fill='url(#Gradient1)' />  <text    x='50%'    y='50%'    class='base'    dominant-baseline='middle'    text-anchor='middle'  >";

    event newNftMinted(address sender, uint256 tokenId);

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

        // Mina o NFT para o msg.sender(quem chamou o contrato) e recebe o id do token(newItemId)
        _safeMint(msg.sender, newItemId);

        // atribui um dado do NFT
        _setTokenURI(newItemId, "data:application/json;base64,ewogICJuYW1lIjogIlR1YmFpbmFNb3F1ZWNhTWFyYWN1amEiLAogICJkZXNjcmlwdGlvbiI6ICJVbSBORlQgc3VwZXIgZmFtb3NvIGRlIHVtYSBjb2xlw6fDo28gZGUgcXVhZHJhZG9zIiwKICAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWndvZ0lIaHRiRzV6UFNKb2RIUndPaTh2ZDNkM0xuY3pMbTl5Wnk4eU1EQXdMM04yWnlJS0lDQndjbVZ6WlhKMlpVRnpjR1ZqZEZKaGRHbHZQU0o0VFdsdVdVMXBiaUJ0WldWMElnb2dJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWdvK0NpQWdQR1JsWm5NK0NpQWdJQ0E4YkdsdVpXRnlSM0poWkdsbGJuUWdhV1E5SWtkeVlXUnBaVzUwTVNJK0NpQWdJQ0FnSUR4emRHOXdJR05zWVhOelBTSnpkRzl3TVNJZ2IyWm1jMlYwUFNJd0pTSXZQZ29nSUNBZ0lDQThjM1J2Y0NCamJHRnpjejBpYzNSdmNESWlJRzltWm5ObGREMGlOVEFsSWk4K0NpQWdJQ0FnSUR4emRHOXdJR05zWVhOelBTSnpkRzl3TXlJZ2IyWm1jMlYwUFNJeE1EQWxJaTgrQ2lBZ0lDQThMMnhwYm1WaGNrZHlZV1JwWlc1MFBnb2dJRHd2WkdWbWN6NEtJQ0E4YzNSNWJHVStDaUFnSUNBdVltRnpaU0I3Q2lBZ0lDQWdJR1pwYkd3NklHSnNkV1U3Q2lBZ0lDQWdJR1p2Ym5RdFptRnRhV3g1T2lCelpYSnBaanNLSUNBZ0lDQWdabTl1ZEMxemFYcGxPaUF5TUhCNE93b2dJQ0FnSUNCamIyeHZjam9nSTBaR1Jqc0tJQ0FnSUgwS0lDQWdJQzV6ZEc5d01TQjdJSE4wYjNBdFkyOXNiM0k2SUdkeVpXVnVPeUI5Q2lBZ0lDQXVjM1J2Y0RJZ2V5QnpkRzl3TFdOdmJHOXlPaUIzYUdsMFpUc2djM1J2Y0MxdmNHRmphWFI1T2lBd095QjlDaUFnSUNBdWMzUnZjRE1nZXlCemRHOXdMV052Ykc5eU9pQjVaV3hzYjNjN0lIMEtJQ0FnSUFvZ0lEd3ZjM1I1YkdVK0NpQWdQSEpsWTNRZ2QybGtkR2c5SWpFd01DVWlJR2hsYVdkb2REMGlNVEF3SlNJZ1ptbHNiRDBpZFhKc0tDTkhjbUZrYVdWdWRERXBJaUF2UGdvZ0lEeDBaWGgwQ2lBZ0lDQjRQU0kxTUNVaUNpQWdJQ0I1UFNJMU1DVWlDaUFnSUNCamJHRnpjejBpWW1GelpTSUtJQ0FnSUdSdmJXbHVZVzUwTFdKaGMyVnNhVzVsUFNKdGFXUmtiR1VpQ2lBZ0lDQjBaWGgwTFdGdVkyaHZjajBpYldsa1pHeGxJZ29nSUQ0S0lDQWdJRlIxWW1GcGJtRk5iM0YxWldOaFRXRnlZV04xYW1FS0lDQThMM1JsZUhRK0Nqd3ZjM1puUGdvPSIKfQo=");
        console.log("NFT com ID %s foi mintado para %s", newItemId, msg.sender);

        // incrementa o Id para o próximo ser diferente desse no próximo mint
        _tokenIds.increment();

        NftsMinted = _tokenIds.current() + 1;

        emit newNftMinted(msg.sender, newItemId);
    }
}