# dapp-auction-multisig-escrow-ipfs-offchain
# dapp-token-crowdsale-ballot
# Auction on Ethereum

This ethereum solution explores escrow with multisig, ipfs, and offchain data.
It is an auction site where products can be listed for bidding.  Product images and description are stored in ipfs.
For better user experience such as filtering, product data is stored in offchain db.
Nodejs subscribes to solidity events and stores the new product information into mongodb. 
 

### Concepts explored
- ipfs
- Storing ethereum data offchain (in this example, using mongodb/nodejs)
- Events
- Interaction between solidity contracts
- Infura provider
- Multisign escrow
