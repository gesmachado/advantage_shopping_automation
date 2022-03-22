*** Settings ***
Resource  ../resource/account_service/ky_account_service.robot
Resource  ../resource/order/ky_order.robot

*** Variables ***

*** Test Cases ***
Teste 2 - Login incorreto
  Que estou autenticando com usuário inválido    user=${usuario_invalido}

*** Keywords ***
