// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HotelManagement{

    struct Hotel{
        string name;
        uint age;
        uint telephone;
    }

    enum Status{
        non_resident
        ,resident
    }
    
    struct Resident{
        string name;
        address wallet_Address;
        uint flat_No;
        uint64 cnic;
        Status status;  //default will be non-resident i.e index 0
    }

    Hotel hotel;
    mapping (address => Resident) Residents;

    constructor(string memory _name, uint _age, uint _telephone)
    {
        hotel.name = _name;
        hotel.age = _age;
        hotel.telephone = _telephone;
    }

    function getHotelDetails() public view returns (string memory,uint, uint)
    {
        return (
        hotel.name, 
        hotel.age, 
        hotel.telephone
        );
    }

    function addResident(address addr, string memory _name, uint flatNo, uint64 _cnic) public returns (bool) {
        require(Residents[addr].status == Status.non_resident, "Already resident!");
        
        //Below lines of this function will execute only if the resident being added does not exist already
        Residents[addr] = Resident(_name, addr, flatNo, _cnic, Status.resident);
        return true;
    }

    function getResidentDetails(address addr) public view returns (string memory, address, uint, uint64) {
      
        require (Residents[addr].status == Status.resident, "Resident does not exist!");
        return (Residents[addr].name,
                Residents[addr].wallet_Address,
                Residents[addr].flat_No,
                Residents[addr].cnic);
    }
}