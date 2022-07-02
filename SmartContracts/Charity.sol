pragma solidity 0.8.7;

contract Charity{

    // Declare state variables of the contract
    address public owner;   // only person who can register needy people
    mapping (address => uint) public moneyRequests; // variable to store requests of people
    mapping (uint => address) private peoples;
    mapping(address => bool) public needyRegisterdpeople;
    uint index =0;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require( msg.sender == owner);
        _;
    }
    // Registering needy People only by owner
    function register(address needy) public onlyOwner{
        needyRegisterdpeople[needy] = true;
        moneyRequests[needy] = 0;
        peoples[index] = needy;
        index++;
    }

    modifier onlyregisteredpeople{
        require(needyRegisterdpeople[msg.sender] == true);
        _;
    }  


    //function to handle Money request only by registered people 
    function moneyRequest(uint amount) public onlyregisteredpeople{
        if(address(this).balance > 1000000000000000000){
            if (address(this).balance -1000000000000000000 >= amount){
                payable(msg.sender).transfer(amount);
            }
            else{
                moneyRequests[msg.sender] = amount -  (address(this).balance -1000000000000000000);
                payable(msg.sender).transfer(address(this).balance -1000000000000000000);
            }
        }
        else {
            moneyRequests[msg.sender] = amount;
        }
    }
    function distributeDonation() public  {
        for(uint i=0; i < index ; i++){

            if(address(this).balance <= 1000000000000000000 ) {
                break;
            }
            if (moneyRequests[peoples[i]] != 0){
                    if (address(this).balance -1000000000000000000 >= moneyRequests[peoples[i]] ){
                       payable(peoples[i]).transfer(moneyRequests[peoples[i]]);
                    }
                    else{
                        moneyRequests[peoples[i]] = moneyRequests[peoples[i]] -  (address(this).balance -1000000000000000000);
                        payable(peoples[i]).transfer(address(this).balance -1000000000000000000);
                    }
                
            }
        }
    }

    // function to recieve donations from people
    receive() external payable {
    } 

    function Donate() public payable{
    }
}