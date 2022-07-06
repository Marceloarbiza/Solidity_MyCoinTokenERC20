// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract MyCoinERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply; // cantidad de tokens emitidos
    mapping(address => uint256) public balanceOf; // la cantidad de tokens que tiene cada address
    mapping(address => mapping(address => uint256)) public allowance; // muestra la  cantidad de tokens que la address autorizada tiene autorizada a manejar
    // la primer address es la dueña de los tokens de origen
    // la segunda address es a la que autorizo a manejar los tokens
    // uint256: es la cantidad de tokens autorizados a manejar

    constructor() {
        name = "My Coin";
        symbol = "MC";
        decimals = 18;
        totalSupply = 1000000 * (uint256(10) ** decimals); //numero de tokens elevado a decimals. al nro de tokens hay que sumarle la cantidad de 0 en decimales que hemos puesto
        balanceOf[msg.sender] = totalSupply; // el que deploya es el dueño de todos los tokens. El constructor se ejecuta una única vez cuando se deploya o se crea una instancia del contrato
                                            
    }   

    event Transfer(address indexed _from, address indexed _to, uint256 _value); // evento para transferir n (_value) tokens de una address (_from) a otra (_to) desde la address de origen que deployó los tokens
    event Approval(address indexed _owner, address indexed _spender, uint256 _value); // evento que registra que se ha autorizado a una cuenta a gestionar determinados tokens

    // ::: TRANSFERIR TOKENS DE UNA ADDRESS ORIGEN A UNA ADDRESS DESTINO ::: 
    // transferir token de una address a otra 
    // _to: address a la que se envía 
    // _value: cantidad de tokens que se envía
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "no tiene suficientes tokens para transferir"); // corroboramos que msg.sender (address que envía) tenga cantidad suficiente para enviar a _to
        balanceOf[msg.sender] -= _value; // bajo la cantidad de tokens a la address que envía
        balanceOf[_to] += _value; // subo la cantidad de tokens a la address que recibe
        emit Transfer(msg.sender, _to, _value); // emitimos el evento para transferir los tokens
        return true; // retornamos true como success
    }


    // ::: AUTORIZAR A UNA ADDRESS A TRANSFERIR N TOKENS A OTRA ADDRESS ::: 

    // autorizo a una address a manejar mis tokens
    // _spender: address que autorizo a manejar los tokens
    // _value: cantidad de tokens que autorizo a manejar
    function approve(address _spender, uint256 _value) public returns (bool success) { // en esta función solo se autroiza a la address a manejar n tokens
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // con esta función se pueden transferir los tokens autorizados de una cuenta a otra
    // _from: cuenta de origen
    // _to: cuenta de destino
    // _value: la cantidad de tokens a transferir
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value); // primero comprobamos que _from tenga esos tokens
        require(allowance[_from][msg.sender] >= _value); // verificamos que quién invoca esta transacción tiene derecho a manejar estos tokens
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value; // compensamos que ahora la cuenta autorizada a manejar n tokens, ahora pueda manejar n - _value tokens
        emit Transfer(_from, _to, _value); // luego de corroborar, se transfieren los tokens
        return true;
    }
}
