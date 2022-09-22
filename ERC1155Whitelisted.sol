//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
contract ERC1155Whitelisted is ERC1155{
    uint constant public nftPrice = 0.2 ether;
    mapping(address => bool) public isWhilelisted;
    address public owner = msg.sender;
    modifier onlyOwner(){
        require(msg.sender==owner,"You are not an Owner");
        _;
    }
    modifier onlyWhitelisted(address _address){
        require(isWhilelisted[_address],"You need to be Whitelisted");
        _; 
    }
    constructor() ERC1155(" "){
        isWhilelisted[owner] = true;
    }

    function addUser(address _toWhitelist) public onlyOwner{
        isWhilelisted[_toWhitelist] = true;
    }

    function mintBatch(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
    public 
    onlyWhitelisted(msg.sender) 
    payable{
        uint sum=0;
        for(uint i=0;i<_amounts.length;i++){
            sum+=_amounts[i];
        }
        require(sum<=5,"You can mint atmost 5 NFT");
        uint256 price = sum*nftPrice;
        require(msg.value >= price, "Not enough ETH sent; check price!");
        _mintBatch(_to, _ids, _amounts, _data);
    }
}
