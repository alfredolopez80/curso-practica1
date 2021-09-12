//SPDX-License-Identifier: ISC
pragma solidity 0.8.4;

import "hardhat/console.sol";

contract Storage {
	bool constant flag = true; // true or false
	uint256 constant num = 12; // Entero sin signo
	string constant message = 'Alfredo'; // Mensaje de texto
	address constant wallet = address(0); // Dirección de una cuenta

	function getStorage() public view virtual {
        console.log("Valor de Storage Flag: ",flag);
		console.log("Valor de Storage Numero: ",num);
		console.log("Valor de Storage Mensaje: ", message);
		console.log("Valor de Storage Wallet: ", wallet);
    }
}

contract Practica is Storage {
	bool internal flag_;
	uint256 public num_;
	string public message_;
	address public wallet_;

    constructor() {
		console.log("Inicio de Contracto");
    }

	function getMemoria() public view {
        console.log("Valor de Flag: ",flag_);
		console.log("Valor de Numero: ",num_);
		console.log("Valor de Mensaje: ", message_);
		console.log("Valor de Wallet: ", wallet_);
    }

	// function getStorage() public view override {
	// 	console.log("Valor de Storage Flag: ",flag_);
	// }

	function setMemoria(bool _flag, uint256 _num, string calldata _msg, address _wallet) public returns (bool, uint256, string memory, address) {
		flag_ = _flag;
		num_ = _num;
		message_ = _msg;
		wallet_ = _wallet;
		return (flag_, num_, message_, wallet_);
	}

}
