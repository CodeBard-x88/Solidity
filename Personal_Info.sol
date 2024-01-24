// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PersonalInfo{

    //struct for Date of birth
    struct DOB{
        uint day;
        uint month;
        uint year;
    }
    
    //state variables
    string name;
    uint age;
    uint64 cnic;
    uint64 passport_Number;
    DOB dob;

    /*******************************Setter Functions for personal info*****************************/
    
    //setter function for name
    function setName(string memory _name) public {
        name=_name;
    }

    //setter function for DOB
    function setDOB(uint _day,uint _month, uint _year) public{
        dob.day = _day;
        dob.month = _month;
        dob.year = _year;
    }

    //setter function for age
    function setAge(uint _age) public {
        age = _age;
    }

    //setter function for cnic
    function setCNIC(uint64 _CNIC) public {
        cnic = _CNIC;
    }

    //setter function for passport number
    function setPassportNumber(uint64 passportNumber) public {
        passport_Number =  passportNumber;
    }

    /*******************************Getter Functions for personal info*****************************/

    // In solidity, a default get function can also be used, by declaring the state variable as public
    //but this method is not preferred because of security risks
    
    //getter for name
    function getName() public view returns(string memory) {
        return name;
    }

    //getter for age
    function getAge() public view returns (uint) {
        return age;
    }

    //getter for cnic
    function getCNIC() public view returns (uint64) {
        return cnic;
    }

    //getter for passport Number 
    function getPassportNumber() public view returns (uint64) {
        return passport_Number;
    }

    //getter for DOB
    function getDOB() public view returns (DOB memory){   //using memory keywords for returning structs
        return dob;
    }

    /*********************************************************************************************/



}