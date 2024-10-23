// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// @dev This Contract is Example of Degen Gaming 
contract GamingClone is ERC20 {

    address public owner;
    mapping(uint256 => string) public ItemName;
    mapping(uint256 => uint256) public Itemprice;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    event Redeem(address indexed user, string itemName);

    constructor(string memory _tokenName, string memory _tokenSymbol) ERC20(_tokenName, _tokenSymbol) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner is allowed to perform this action.");
        _;
    }

    function GameStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) public onlyOwner {
        ItemName[itemId] = _itemName;
        Itemprice[itemId] = _itemPrice;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public  {
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function Itemredeem(uint256 accId) public returns (string memory) {
        require(Itemprice[accId] > 0, "User have to provide a valid ItemID");
        uint256 redemptionAmount = Itemprice[accId];
        require(balanceOf(msg.sender) >= redemptionAmount, "Insufficient balance to redeem the item.");

        _burn(msg.sender, redemptionAmount);
        redeemedItems[msg.sender][accId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, ItemName[accId]);

        return ItemName[accId];
    }

    function getRedeemedItemCount(address user) public view returns (uint256) {
        return redeemedItemCount[user];
    }
}