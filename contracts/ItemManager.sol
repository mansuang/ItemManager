pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    enum SupplyChainState{Created, Paid, Delivered}
    
    struct S_Item {
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    mapping(uint => S_Item ) public items;    
    uint itemIndex;
    
    event SupplyChainStep(uint _itemIndex, uint _step);
    
    function createItem(string memory _identifier, uint _itemPrice) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
        itemIndex++;
    }
    
    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain");
        
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
        
    }
    
    function tiggerDelivery(uint _itemIndex) public payable {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is further in the chain");
        
        items[_itemIndex]._state = SupplyChainState.Delivered;        
        
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
    }    
}