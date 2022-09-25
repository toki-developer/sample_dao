//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./iTkoToken.sol";

contract TkoToken is iTkoToken, ERC721, Ownable, ReentrancyGuard {

    using Strings for uint256;

    uint256[5] public PRICE = [0.03 ether, 0.05 ether, 0.07 ether, 0.1 ether, 0.3 ether];
    uint256[5] public _nextTokenIdListByRank = [1, 100001, 200001, 300001, 400001];
    address payable private _recipient;
    bool private _isOnSale;
    // bool private _isMetadataFroze;
    // string private __baseURI;
    constructor(address payable __recipient) ERC721("TkoToken", "TKO") {
        require(__recipient != address(0), "TkoToken: Invalid address");
        _recipient = __recipient;
    }

    modifier onSale() {
        require(_isOnSale, "TkoToken: Not on sale");
        _;
    }

    //******************************
    // view functions
    //******************************

    function isOnSale() external view override returns (bool) {
        return _isOnSale;
    }

    function nextTokenId(uint256 rank) external view override returns (uint256) {
        return _nextTokenIdListByRank[rank - 1];
    }

    // function _baseURI() internal override view virtual returns (string memory) {
    //     return __baseURI;
    // }

    // 全て外部に保存する場合
    // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    //     require(_exists(tokenId), "TkoToken: URI query for nonexistent token");

    //     string memory baseURI = _baseURI();
    //     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    // }

    // 画像だけ外部、残りのmetadataをコントラクト上にする場合
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        require(_exists(tokenId), "TkoToken: URI query for nonexistent token");

        uint256 rank = ( tokenId / 100000 ) + 1;

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(bytes(abi.encodePacked('{"name":"TkoToken #',  Strings.toString(tokenId),'","description": "This is Tko Token","attributes":[{ "trait_type": "Rank", "value":', Strings.toString(rank),' }],"image": "https://gr2v2wtpgux5jwj5aq6vwu5iaoxv5vub5fihr5ul3irmp3rvie7a.arweave.net/NHVdWm81L9TZPQQ9W1OoA69e1oHpUHj2i9oix-41QT4"}')))
            )
        );
    }

    //******************************
    // public functions
    //******************************

    function buy(uint256 rank) external override onSale nonReentrant payable {
        require((rank > 0) && (rank < 6) , "TkoToken: Invalid rank");
        require(msg.value == PRICE[rank- 1], "TkoToken: Invalid value");
        require(_nextTokenIdListByRank[rank - 1] % 100000 != 0, "TkoToken: Sold out");

        uint256 tokenId = _nextTokenIdListByRank[rank - 1];
        _nextTokenIdListByRank[rank - 1] ++;

        _safeMint(_msgSender(), tokenId);
    }

    //******************************
    // admin functions
    //******************************

     function updateSaleStatus(bool __isOnSale) external override onlyOwner {
        _isOnSale = __isOnSale;
    }

    // function updateBaseURI(string calldata newBaseURI) external override onlyOwner {
    //     require(!_isMetadataFroze, "TkoToken: Metadata is froze");

    //     __baseURI = newBaseURI;
    // }

    // function freezeMetadata() external override onlyOwner {
    //     require(!_isMetadataFroze, "TkoToken: Already froze");
    //     _isMetadataFroze = true;
    // }

    function withdrawETH() external override onlyOwner {
        Address.sendValue(_recipient, address(this).balance);
    }

    function setRecipient(address payable __recipient) external override onlyOwner {
        _recipient = __recipient;
    }
}

