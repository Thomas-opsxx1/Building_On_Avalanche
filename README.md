# GamingClone - Degen Gaming Token Contract

## Project Objective

**Description**  
The goal of this project is to create a custom ERC20 token for Degen Gaming, aimed at enhancing player engagement and retention. This token will serve as an in-game currency that players can earn through gameplay and exchange for rewards in the game's virtual store. The token will be deployed on the Avalanche blockchain, a platform known for its fast transactions and low fees, making it ideal for gaming applications.

The project involves developing a smart contract that enables various functionalities, including token minting, transferring, redeeming for in-game rewards, and burning unwanted tokens. By integrating this token into Degen Gaming's ecosystem, players can enjoy a more interactive experience through earning, trading, and using tokens for exclusive in-game content. This will provide a unique reward mechanism that encourages deeper engagement and loyalty among players.

## Key Features

- **Minting Tokens:** The contract allows the platform owner to mint new tokens and distribute them as rewards to players.
- **Transferring Tokens:** Players can transfer tokens to each other, enabling a vibrant in-game economy.
- **Redeeming Tokens:** Players can exchange tokens for items in the in-game store by using a redemption function.
- **Checking Balances:** Players can check their token balances at any time, offering transparency in their rewards.
- **Burning Tokens:** Players can burn tokens that are no longer needed, reducing the overall token supply.

## Smart Contract Overview

```solidity
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
```

The `GamingClone` contract is an ERC20 token implementation with added functionality to support in-game operations. Below is a breakdown of the contract features:

### Functions

1. **`mint(address to, uint256 amount)`**  
   Allows the owner of the contract to mint new tokens and assign them to a player's address as a reward.

2. **`burn(uint256 amount)`**  
   Allows players to burn tokens they own, permanently removing them from circulation.

3. **`transfer(address to, uint256 value)`**  
   Enables players to transfer tokens to other players, fostering an in-game economy.

4. **`GameStore(uint256 itemId, string memory _itemName, uint256 _itemPrice)`**  
   The owner can add items to the in-game store with specified prices, enabling the redemption of tokens for rewards.

5. **`Itemredeem(uint256 accId)`**  
   Allows players to redeem their tokens for items in the store. It checks if the player has sufficient tokens and burns the necessary amount upon successful redemption.

6. **`getRedeemedItemCount(address user)`**  
   Provides the total number of items a player has redeemed, helping track their reward history.

### Events

- **`Redeem(address indexed user, string itemName)`**:  
  Logs when a player successfully redeems an item, recording the player’s address and the redeemed item name.

## How to Deploy

1. **Set up the Avalanche environment:**  
   Use tools like Hardhat or Truffle with the Avalanche network configurations.

2. **Deploy the Contract:**  
   Compile the `GamingClone` contract and deploy it to the Avalanche blockchain using the specified network settings.

3. **Initialize the Contract:**  
   Set the token name and symbol when deploying the contract.

4. **Mint Initial Supply:**  
   Use the `mint` function to distribute the initial supply of tokens to the game’s reward pool.

## How to Use

- **For Game Admins:**  
  - Mint new tokens for players.
  - Add new items to the store with prices.
  
- **For Players:**  
  - Check their token balance.
  - Transfer tokens to friends or other players.
  - Redeem tokens for exclusive in-game items.
  - Burn tokens they no longer wish to hold.

## Prerequisites

- Basic knowledge of Solidity and ERC20 token standards.
- Understanding of Avalanche network setup.
- Experience with Ethereum-compatible wallets like MetaMask.

## Conclusion

This project aims to bring a new level of engagement to Degen Gaming by offering players a way to earn and utilize tokens within the game. By leveraging the power of the Avalanche blockchain, this project ensures a smooth and cost-effective gaming experience, fostering a vibrant community of players who are rewarded for their efforts. Happy coding, and good luck with the challenge!
