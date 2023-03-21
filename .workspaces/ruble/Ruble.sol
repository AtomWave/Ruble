Pragma solidity ^0.4.4;
контракт Token {
/// @return суммарное количество токенов
 function totalSupply() constant returns (uint256 supply) {}
/// @param _owner Адрес, с которого будет получен баланс
 /// @return Баланс
 function balanceOf(address _owner) constant returns (uint256 balance) {}
/// @notice отправьте `_value` токенов на `_to` с  `msg.sender`
 /// @param _to Адрес получателя
 /// @param _value Сумма токенов к переводу
 /// @return Успешный или неуспешный перевод
 function transfer(address _to, uint256 _value) returns (bool success) {}
/// @notice отправьте `_value` токенов на `_to` с `_from` при условии, что это разрешено `_from`
 /// @param _from Адрес отправителя
 /// @param _to Адрес получателя
 /// @param _value Сумма токенов к переводу
 /// @return Успешный или неуспешный перевод
 function approve(address _spender, uint256 _value) returns (bool success) {}
 /// @notice `msg.sender` разрешает `_addr` потратить `_value` токенов
 /// @param _spender Адрес счета для перевода токенов
 /// @param _value Сумма wei, разрешенная к переводу
 /// @return Разрешение получено или нет
 function approve(address _spender, uint256 _value) returns (bool success) {}
/// @param _owner Адрес счета, владеющего токенами
 /// @param _spender Адрес счета для перевода токенов
 /// @return Сумма остатка токенов, которую можно потратить
 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
событие Transfer(address indexed _from, address indexed _to, uint256 _value);
событие Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
контракт StandardToken - это Token {
function transfer(address _to, uint256 _value) returns (bool success) {
 //Default означает, что totalSupply не может быть больше макс. (2²⁵⁶ — 1).
 //Если ваш токен выпускает totalSupply и со временем сможет выпустить еще больше токенов, вам нужно убедиться в том, что он не будет обертываться (wrap-эффект).
 // if замените этим.
 //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
 if (balances[msg.sender] >= _value && _value > 0) {
 balances[msg.sender] -= _value;
 balances[_to] += _value;
 Transfer(msg.sender, _to, _value);
 return true;
 } else { return false; }
 }
function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
 //как выше. Замените эту строку на следующую, если хотите обезопасить себя от обертывания uints.
 //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
 balances[_to] += _value;
 balances[_from] -= _value;
 allowed[_from][msg.sender] -= _value;
 Transfer(_from, _to, _value);
 return true;
 } else { return false; }
 }
function balanceOf(address _owner) returns returns (uint256 balance) {
 return balances[_owner];
 }
function approve(address _spender, uint256 _value) returns (bool success) {
 allowed[msg.sender][_spender] = _value;
 Approval(msg.sender, _spender, _value);
 return true;
 }
function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
 return allowed[_owner][_spender];
 }
mapping (address => uint256) balances;
mapping (address => mapping (address => uint256)) allowed;
 uint256 public totalSupply;
}
//назовите этот контракт, как хотите
контракт ERC20Token – это StandardToken {
function () {
 //если эфир отправляется на этот адрес, отправьте его обратно.
 throw;
 }
/* Общедоступные переменные токена */
/*
Примечание:
следующие переменные являются необязательными, т.е. необязательно их включать.
Они просто позволяют настроить токен-контракт и никак не влияют на основной функционал.
Некоторые кошельки / интерфейсы могут даже не с реагировать на эту информацию. 
 */
общедоступное название строки; //вымышленное имя: например, Simon Bucks
общедоступные десятичные uint8; //Сколько десятичных знаков показывать, т.е. может быть 1000 базовых единиц с 3 десятичными. Значение 0.980 SBX = 980 базовым единицам. Это как сравнивать 1 wei с 1 эфиром.
общедоступное название строки; //Идентификатор: напр., SBX
общедоступное название строки = ‘H1.0’; //human 0.1 standard. Просто произвольная многоверсионная схема.
//
// ПОМЕНЯЙТЕ ЭТИ ЗНАЧЕНИЯ ДЛЯ ВАШЕГО ТОКЕНА
//
//убедитесь, что название этой функции соответствует имени контракта выше. Если ваш токен называется TutorialToken, убедитесь, что // имя контракта выше также TutorialToken, а не ERC20Token
function ERC20Token(
 ) {
 balances[msg.sender] = 50000; // передайте создателю все исходные токены (100000, например)
 totalSupply = 100000; // Обновите общее количество (100000, например)
 имя = “Ruble”; // Установите имя для отображения
 десятичные = 10; // Количество десятичных для отображения
 символ = “RUB”; // Установите символ для отображения
 }
/* Утверждает и затем вызывает получающий контракт */
function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
 allowed[msg.sender][_spender] = _value;
 Approval(msg.sender, _spender, _value);
// вызовите функцию receiveApproval в контракте, о котором вы хотите получить уведомление. Это обрабатывает подпись функции вручную, так что не нужно включать контракт сюда только для этого.
 //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
 //предполагается, что при этом вызов *должен* завершиться успешно, в противном случае вместо него будет использоваться Vanilla approve.
 if(!_spender.call(bytes4(bytes32(sha3(“receiveApproval(address,uint256,address,bytes)”))), msg.sender, _value, this, _extraData)) { throw; }
 return true;
 }
}