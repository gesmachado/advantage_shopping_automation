*** Settings ***
Library  RequestsLibrary
Library  OperatingSystem
Resource  ../account_service/ky_account_service.robot

*** Variables ***


*** Keywords ***
Eu adiciono um produto no carrinho
  [Arguments]  ${user}  ${product_id}  ${color}  ${warranty}  ${quantity}
  Log To Console    message=Adicionando produto no carrinho

  ${headers}  Create Dictionary
  ${response}  POST On Session    alias=${ALIAS_GLOBAL}  url=/order/api/v1/carts/${user}[3]/product/${product_id}/color/${color}?hasWarranty=${warranty}&quantity=${quantity}  headers=${headers}  expected_status=201

  Log To Console    message=${response.json()}

Eu confiro o produto no carrinho
  [Arguments]  ${user}
  Log To Console    message=conferir produto no carrinho

  ${headers}  Create Dictionary
  ${response}  GET On Session    alias=${ALIAS_GLOBAL}  url=/order/api/v1/carts/${user}[3]  headers=${headers}  expected_status=200

  Log To Console    message=${response.json()}

Eu limpo o carrinho do cliente
  [Arguments]  ${user}
  Log To Console    message=conferir produto no carrinho

  ${headers}  Create Dictionary
  ${response}  DELETE On Session    alias=${ALIAS_GLOBAL}  url=/order/api/v1/carts/${user}[3]  headers=${headers}  expected_status=200

  Log To Console    message=${response.json()}
