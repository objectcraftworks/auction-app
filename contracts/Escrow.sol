pragma solidity ^0.4.13;

contract Escrow {

    uint public productId;
    // Escrow 
    address public buyer;
    address public seller;
    address public arbiter;
    // amount & fundsDisbursed?
    uint public amount;
    bool public fundsDisbursed;
    // releaseAmount? 
    mapping (address => bool) releaseAmount;

    uint public releaseCount;
    //refund ?
    mapping (address => bool) refundAmount;
    uint public refundCount;

    event CreateEscrow(uint _productId, address _buyer, address _seller, address _arbiter);
    event UnlockAmount(uint _productId, string _operation, address _operator);
    event DisburseAmount(uint _productId, uint _amount, address _beneficiary);

    function Escrow(
        uint _productId,
        address _buyer, 
        address _seller,
        address _arbiter
    ) payable public 
    {
        productId = _productId;
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;
        fundsDisbursed = false;
        CreateEscrow(_productId, _buyer, _seller, _arbiter);
    }

    function releaseAmountToSeller(address caller) public {
        //make sure funds availabke
        require(!fundsDisbursed);
        // caller should be one of three known parties
        if ((caller == buyer || caller == seller || caller == arbiter) && releaseAmount[caller] != true) {
            // make a mark the intention of the caller
            releaseAmount[caller] = true;
            //increment the party's consent
            releaseCount += 1;
            //ReleaseAmountRequest Event?   
            UnlockAmount(productId, "release", caller);
        }
        // when two parties give consent 
        if (releaseCount == 2) {
            //transfer the money to the seller   
            seller.transfer(amount);
            // 
            fundsDisbursed = true;
            //fire event = ReleasedAmountToSeller 
            DisburseAmount(productId, amount, seller);
        }
    }

    function refundAmountToBuyer(address caller) public {
        require(!fundsDisbursed);
        if ((caller == buyer || caller == seller || caller == arbiter) && refundAmount[caller] != true) {
            refundAmount[caller] = true;
            refundCount += 1;
            UnlockAmount(productId, "refund", caller);
        }

        if (refundCount == 2) {
            //send to the buyer
            buyer.transfer(amount);
            fundsDisbursed = true;
            DisburseAmount(productId, amount, buyer);
        }
    }
    
    function escrowInfo() view public returns (address, address, address, bool, uint, uint) {
        return (buyer, seller, arbiter, fundsDisbursed, releaseCount, refundCount);
    }
}