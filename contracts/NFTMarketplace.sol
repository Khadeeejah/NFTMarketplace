// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./MusicCover.sol";

contract Marketplace is ReentrancyGuard, MusicCover {
    using Counters for Counters.Counter;
    // increments when a NFT is sold and decremented when a NFT is relisted.
    // Counters.Counter private _nftsSold;
    // tracks how many types of NFTs have been listed.
    Counters.Counter private _nftCount;
    // is taken from the seller and transferred to the marketplace contract owner whenever an NFT is sold.
    uint256 public LISTING_FEE = 0.0001;
    // stores the Marketplace contract owner, so that we know who to pay the listing fee to
    address payable private _marketOwner;
    // associates the unique tokenId to a the NFT struct.
    mapping(string => NFT) public _idToNFT;
    // associates an address to nfts listed by them
    mapping(address => NFT[]) public authorStore;
    //  stores relevant information for an NFT listed in the marketplace
    struct NFT {
        address payable seller;
        uint256 price;
        bool listed;
        uint256 quantity;
        address[] owners;
        string tokenId;
        string songName;
        string producer;
        string genre;
    }
    // is emitted every time a NFT is Listed.
    event NFTListed(address seller, uint256 quantity, uint256 price);
    // is emitted every time a NFT is sold.
    event NFTSold(address seller, address buyer, uint256 price);

    constructor() {
        _marketOwner = payable(msg.sender);
    }

    // List the NFT on the marketplace
    function listNft(
        string memory _tokenUri,
        uint256 _price,
        uint256 _quantity
    ) public payable nonReentrant {
        address[] memory _owners;
        require(_price > 0, "Price must be at least 1 wei");
        require(_quantity > 0, "Quantity must be greater than 0");
        require(nftExists(_tokenUri) != true, "NFT already exists");
        require(msg.value == LISTING_FEE, "Not enough ether for listing fee");
        // increment nft type count
        _nftCount.increment();
        //mint one nft for the artist
        MusicCover.mintNFT(_tokenUri);
        // map nft to its id
        _idToNFT[_tokenUri] = NFT(
            payable(msg.sender),
            _price,
            true,
            _quantity,
            _owners,
            _tokenUri
        );
        //add to artist's store
        artistStore[msg.sender].push(
            NFT(
                payable(msg.sender),
                _price,
                true,
                _quantity,
                _owners,
                _tokenUri
            )
        );
        // send listing fee to market owner
        payable(_marketOwner).transfer(msg.value);

        emit NFTListed(msg.sender, _quantity, _price);
    }

    // Buy an NFT
    function buyNft(string memory _tokenUri) public payable nonReentrant {
        NFT storage nft = _idToNFT[_tokenUri];
        require(nftExists(_tokenUri) == true, "NFT does not exist");
        require(
            msg.value == nft.price,
            "Not enough or too much ether to cover asking price"
        );
        require(nft.owners.length < nft.quantity, "NFTs maxed out");
        //mint one nft for the buyer
        MusicCover.mintNFT(_tokenUri);
        // add to owners of nft
        nft.owners.push(msg.sender);
        _idToNFT[_tokenUri] = nft;
        // update the author's store
        NFT[] storage _store = authorStore[nft.seller];
        for (uint256 i = 0; i < _store.length; ++i) {
            if (
                keccak256(abi.encodePacked(_store[i].tokenId)) ==
                keccak256(abi.encodePacked(nft.tokenId))
            ) {
                _store[i].owners = nft.owners;
                authorStore[nft.seller] = _store;
            }
        }
        // send money to seller
        address payable buyer = payable(msg.sender);
        payable(nft.seller).transfer(msg.value);
        // IERC721(_nftContract).transferFrom(address(this), buyer, nft.tokenId);
        // _marketOwner.transfer(LISTING_FEE);
        // nft.owner = buyer;
        // nft.listed = false;

        // _nftsSold.increment();
        emit NFTSold(nft.seller, buyer, msg.value);
    }

    function nftExists(string memory _tokenUri) public view returns (bool) {
        NFT memory sample = _idToNFT[_tokenUri];
        if (sample.price == 0 || sample.quantity == 0) {
            return false;
        } else {
            return true;
        }
    }

    function getNftOwners(
        string memory _tokenUri
    ) public view returns (address[] memory) {
        require(nftExists(_tokenUri) == true, "NFT does not exist");
        NFT memory sample = _idToNFT[_tokenUri];
        return sample.owners;
    }

    function getListingFee() public view returns (uint256) {
        return LISTING_FEE;
    }
}
