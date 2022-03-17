*** Settings ***
Resource  ../resource/account_service/ky_account_service.robot
Resource  ../resource/order/ky_order.robot

*** Variables ***

*** Test Cases ***
Teste 3 - Usuário novo
  Given Eu crio um usuário novo    user=${user_novo}
  When Que estou autenticado    user=${user_adm}
  Then Eu excluo um usuário

*** Keywords ***
