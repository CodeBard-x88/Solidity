// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SubscriptionManagement{
    
    enum UserStatus {
        unregistered,
        blocked,
        registered
    }

    enum SubscriptionStatus{
        expired,
        valid
    }

    enum SubscriptionType{
        weekly,
        monthly,
        yearly
    }

    struct OwnedSubscription{
        string name;
        SubscriptionType subscription_Type;
        SubscriptionStatus subscription_Status;
        bool owned;
    }

    struct User{
        string name;
        uint cnic;
        address wallet_Address;
        UserStatus user_Status;
        string active_Subscription_Name;
    }
    
    address owner;
    mapping(string => bool) available_Subscriptions;
    mapping(string => uint) available_Subscription_Price;
    mapping (address => User) registered_Users;
    mapping (address => mapping (string => OwnedSubscription)) user_Subscriptions;

    constructor()
    {
        owner = msg.sender;
    }

    modifier onlyNonRegistered(address addr){
        require(registered_Users[addr].user_Status == UserStatus.unregistered, "This User is already registered!");
        _;
    }

    modifier onlyRegisteredUser(address addr){
        require(registered_Users[addr].user_Status == UserStatus.registered, "This User is not registered or either have been blocked!");
        _;
    }

    modifier onlyOwner(address addr){
        require(msg.sender == owner, "You are not authorized to use this functionality.");
        _;
    }

    modifier isNewOffer(string memory name){
        require(available_Subscriptions[name]==false, "This offer exists already.");
        _;
    }

    function Register(string memory _name, uint _cnic,address walletAddress) public onlyNonRegistered(walletAddress) {
        registered_Users[walletAddress] = User(_name,_cnic,walletAddress,UserStatus.registered,"");
    }

    function BuySubscription(string memory subscriptionName, uint subscription_Period) external payable  onlyRegisteredUser(msg.sender){
        
        require (available_Subscriptions[subscriptionName]==true, "The subscription is not available!");
        require (available_Subscription_Price[subscriptionName] == msg.value, "The value is not equal to the Subscription Price.");
        require (subscription_Period == 7 || subscription_Period == 30 || subscription_Period == 365, "The subscription Period enterd is not a valid. Please enter 7 or 30 or 365.");
        
        SubscriptionType subType;
        if (subscription_Period==7){
            subType = SubscriptionType.weekly;
        }
        else if(subscription_Period == 30){
            subType = SubscriptionType.monthly;
        }
        else {
            subType = SubscriptionType.yearly;
        }

        payable(owner).transfer(msg.value);
        user_Subscriptions[msg.sender][subscriptionName] = OwnedSubscription(subscriptionName,subType,SubscriptionStatus.valid,true);
    }

    function addOffers(string memory name, uint _price) external onlyOwner(msg.sender) isNewOffer(name) {
        available_Subscriptions[name] = true;
        available_Subscription_Price[name] = _price;
    }


    function Unsubscribe() external onlyRegisteredUser(msg.sender) {
        // This function will unsubscribe from the currently active subscription
        User storage user = registered_Users[msg.sender];
        string memory activeSubscriptionName = user.active_Subscription_Name;
        require(bytes(activeSubscriptionName).length > 0, "No active subscription to unsubscribe from");
        OwnedSubscription storage activeSubscription = user_Subscriptions[msg.sender][activeSubscriptionName];
        require(activeSubscription.owned, "Subscription is not owned by the user");
        activeSubscription.owned = false;
        user.active_Subscription_Name ="";
    }

    function changeActiveSubscription(string memory name) external onlyRegisteredUser(msg.sender) {
        require(user_Subscriptions[msg.sender][name].owned && user_Subscriptions[msg.sender][name].subscription_Status == SubscriptionStatus.valid, "This subscription has either expired or you did not own it.");
        User storage user = registered_Users[msg.sender];
        user.active_Subscription_Name = name;
    }

    function getCurrentSubscriptionDetails() external view onlyRegisteredUser(msg.sender) returns (OwnedSubscription memory) {
        User storage user = registered_Users[msg.sender];
        string memory activeSubscriptionName = user.active_Subscription_Name;
        require(bytes(activeSubscriptionName).length > 0, "There is no current active subscription.");
        return user_Subscriptions[msg.sender][activeSubscriptionName];
    }
}