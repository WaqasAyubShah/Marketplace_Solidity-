// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

//internal imports for nft openzeppelin 
//import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itmesSold;

    uint256 listingPrice = 0.0015 ether;

    address payable owner;
    mapping(uint256 => MarketItem) private idMarketItem;

    struct MarketItem{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    modifier onlyOwner(){
        require( msg.sender == owner, "only owner can call it"); 
        _;
    }

    constructor() ERC721("NFT Marketplace", "MyNFT"){
        owner == payable(msg.sender);
    }

    function updatelistingPrice(uint256 _listingPrice) public payable onlyOwner{
        listingPrice = _listingPrice;
    }


    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }
    function createToken(string memory tokenURI, uint256 price) public payable return(uint256){
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        createMarketItem(newTokenId, price);

        return newTokenId;
    }
    //creating market items 
    function createMarketItem(uint256 tokenid, uint256 price) private {
        require(price > 0 , "Price must be atleast 1");
        require(msg.value == listingPrice, "Price must be equal to listing");

        idMarketitem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)), 
            price,
            false,
        );

        _transfer(msg,sender, address(this), tokenId);
        emit MarketItemCreated(tokenId, msg.sender, address(this) , price, false);
    }

    //Function for resale token
    function reSellToken(uint256 tokenId, uint256 price) public payable {
        require(idMarketItem[tokenId].owner == msg.sender, "only owner can sell");
        require(msg.value == listingPrice, "Price must be equal to listing");

        idMarketItem[tokenId].sold = false;
        idMarketItem[tokenId].price = price;
        idMarketItem[tokenId].seller = payable(msg.sender);
        idMarketItem[tokenId].owner = payable(address(this));

        _itemSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
    }

    //function create market sale

    function createdMarketSale(uint256 tokenId) public payable{
        uint256 price = idMarketItem[tokenId].price;

        require(msg.value == price, "please submit the asking price");

        idMarketItem[tokenId].owner = payable(msg.sender);
        idMarketItem[tokenId].sold = true;
        idMarketItem[tokenId].owner = payable(address(0));

        _itemsSold.increment();

        _transfe(address(this), msg.sender, tokenId);

        payable(owner).transfer(listingPrice);
        payable(idMarketItem[tokenId].seller).transfer(msg.value);
    }
    
    //getting the data back 
    function fetchMarketItem() public view returns(MarketItem[] memory){
        uint256 itemCount = _tokenIds.current();
        uint256 unsoldCount = _tokenIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;
        MarketItem[] memory items = new MarketItem[](unSoldItemCount);
        for(uint256 i = 0; i < itemCount; i++)
        {
            if(idMarketItem[ i +1].owner == address(this)){
                uint2567 currentId = i + 1; 
                MarketItem storage currentItem = idMarketItem[currentId];

                item[currentIndex] = currentItem;
                currentIndex +=1;
            }
        }
        return items;

    }

    //purchase item
    function fetchMyNFT() public view returns(MarketItem[] memory)
        {
            uint256 totalCount = _tokenIds.current();
            uint256 itemCount = 0;
            uint256 currentIndex = 0;

            for(uint256 i = 0; i < totalCount; i++){
                if(idMarketItem[i+1].owner == msg.sender ){
                    itemCount += 1;
                }
            }

            MarketItem[] memory items = new MarketItem [](itemCount);
            for(uint256 i= 0; i < itemCount; i++){
                if(idMarketItem[i+1].owner == msg.sender){
                    uint256 currentId = i+1;
                    MarketItem storage currentItem = idMarketItem[currentId];
                    items[currentIndex] = currentItem;
                    currentItem +=1;
                }
                
            }
            return items;
        }
    
    //Single user Items
    function fetchItemsListed() public view returns (MarketItem[] memory ){
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for(uint256 i= 0; i < totalCount; i++){
            if(idMarketItem[i+1].seller == msg.sender){
                itemCount +=1;
            }
        }
        MarketItem[] memory item = new MarketItem[](itemCount);
        for(uint256 i=0; i< totalCount; i++){
            if(idMarketItem[i+1].seller == msg.sender){
                uint256 currentId = i+1;
                MarketItem storage currentItem = idMarketItem[currentId];
                item[currentIndex] = currentItem;
                currentIndex +=1;
            }
        }
        return items;
    }

    
}

