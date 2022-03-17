*** Settings ***
Library  RequestsLibrary
Library  OperatingSystem
Library  String
Library  JSONLibrary

*** Variables ***
@{user_gesmachado}  teste@teste.com  Senh@123  gesmachado  743509267
@{user_adm}  teste@teste.com  Senh@123  gesmachado_adm  103747275
@{usuario_invalido}  teste@teste.com  Senh@123  xxxxx  123456789
${ALIAS_TOKEN}  ALIAS_TOKEN
${ALIAS_GLOBAL}  ALIAS_GLOBAL
${server}  http://www.advantageonlineshopping.com
&{user_novo}  accountType=USER  address=Minha casa  allowOffersPromotion=false  aobUser=false  cityName=Uberlândia  country=BRAZIL_BR  email=teste@teste.com  firstName=Gustavo  lastName=Machado  loginName=gesmachado1  password=Senh@123  phoneNumber=19999999999  stateProvince=MG  zipcode=38412582

*** Keywords ***
Que estou autenticado
  [Arguments]  ${user}
  Log To Console    message=Realizando o login de ${user}[2]

  # Get json
  ${body}  Get File    path=${EXECDIR}/src/resource/account_service/login_template.json
  ${body}  Convert To String    item=${body}

  # Replace
  ${body}  Replace String Using Regexp    ${body}    _email    ${user}[0]
  ${body}  Replace String Using Regexp    ${body}    _senha    ${user}[1]
  ${body}  Replace String Using Regexp    ${body}    _user    ${user}[2]

  ${json_body}  Convert String to JSON    ${body}

  # Sessão para autenticar
  ${headers}  Create Dictionary
  Create Session    alias=${ALIAS_TOKEN}    url=${server}
  ${response}  POST On Session    alias=${ALIAS_TOKEN}  url=/accountservice/accountrest/api/v1/login  json=${json_body}    headers=${headers}  expected_status=200
  ${TOKEN}  Set Variable       ${response.json()['statusMessage']['token']}

  # Sessão para executar outros request
  ${headers}  Create Dictionary  Authorization=Bearer ${TOKEN}
  Create Session    alias=${ALIAS_GLOBAL}    url=${server}  headers=${headers}

  Set Global Variable   ${TOKEN_GLOBAL}    ${TOKEN}

Eu faço o logout
  [Arguments]  ${user}
  Log To Console    message=Realizando o logout de ${user}[2]

  # Get json
  ${body}  Get File    path=${EXECDIR}/src/resource/account_service/logout_template.json
  ${body}  Convert To String    item=${body}

  # Replace
  ${body}  Replace String Using Regexp    ${body}    _account_id    ${user}[3]
  ${body}  Replace String Using Regexp    ${body}    _token    ${TOKEN_GLOBAL}

  ${json_body}  Convert String to JSON    ${body}

  ${headers}  Create Dictionary
  ${response}  POST On Session    alias=${ALIAS_GLOBAL}  url=/accountservice/accountrest/api/v1/logout  json=${json_body}    headers=${headers}  expected_status=200

  ${logout_messsage}  Set Variable    ${response.json()['response']['reason']}
  Should Be Equal    ${logout_messsage}    Logout Successful

  Log To Console    message=${response.json()['response']['reason']}

Que estou autenticando com usuário inválido
  [Arguments]  ${user}
  Log To Console    message=Realizando o login de ${user}[2]

  # Get json
  ${body}  Get File    path=${EXECDIR}/src/resource/account_service/login_template.json
  ${body}  Convert To String    item=${body}

  # Replace
  ${body}  Replace String Using Regexp    ${body}    _email    ${user}[0]
  ${body}  Replace String Using Regexp    ${body}    _senha    ${user}[1]
  ${body}  Replace String Using Regexp    ${body}    _user    ${user}[2]

  ${json_body}  Convert String to JSON    ${body}

  # Sessão para autenticar
  ${headers}  Create Dictionary
  Create Session    alias=${ALIAS_TOKEN}    url=${server}
  ${response}  POST On Session    alias=${ALIAS_TOKEN}  url=/accountservice/accountrest/api/v1/login  json=${json_body}    headers=${headers}  expected_status=403

  Log To Console    message=${response.json()['statusMessage']['reason']}

Eu crio um usuário novo
  [Arguments]  ${user}
  Log To Console    message=Criando um novo usuário ${user.loginName}

  # Get json
  ${body}  Get File    path=${EXECDIR}/src/resource/account_service/create_user.json
  ${body}  Convert To String    item=${body}

  # Replace
  ${body}  Replace String Using Regexp    ${body}    _accountType    ${user.accountType}
  ${body}  Replace String Using Regexp    ${body}    _address    ${user.address}
  ${body}  Replace String Using Regexp    ${body}    _allowOffersPromotion    ${user.allowOffersPromotion}
  ${body}  Replace String Using Regexp    ${body}    _aobUser    ${user.aobUser}
  ${body}  Replace String Using Regexp    ${body}    _cityName    ${user.cityName}
  ${body}  Replace String Using Regexp    ${body}    _country    ${user.country}
  ${body}  Replace String Using Regexp    ${body}    _email    ${user.email}
  ${body}  Replace String Using Regexp    ${body}    _firstName    ${user.firstName}
  ${body}  Replace String Using Regexp    ${body}    _lastName    ${user.lastName}
  ${body}  Replace String Using Regexp    ${body}    _loginName    ${user.loginName}
  ${body}  Replace String Using Regexp    ${body}    _password    ${user.password}
  ${body}  Replace String Using Regexp    ${body}    _phoneNumber    ${user.phoneNumber}
  ${body}  Replace String Using Regexp    ${body}    _stateProvince    ${user.stateProvince}
  ${body}  Replace String Using Regexp    ${body}    _zipcode    ${user.zipcode}

  ${json_body}  Convert String to JSON    ${body}

  # Sessão para autenticar
  ${headers}  Create Dictionary
  Create Session    alias=${ALIAS_TOKEN}    url=${server}
  ${response}  POST On Session    alias=${ALIAS_TOKEN}  url=/accountservice/accountrest/api/v1/register  json=${json_body}    headers=${headers}  expected_status=200

  Log To Console    message=${response.json()}

  Set Test Variable  ${client_id}  ${response.json()['response']['userId']}

Suas credenciais estão disponíveis

Eu excluo um usuário
  Log To Console    message=Excluir usuário

  # Get json
  ${body}  Get File    path=${EXECDIR}/src/resource/account_service/delete_user_template.json
  ${body}  Convert To String    item=${body}

  ${client_id_str}  Convert To String    ${client_id}
  # Replace
  ${body}  Replace String Using Regexp  ${body}   _accountId    ${client_id_str}
  ${json_body}  Convert String to JSON    ${body}

  ${headers}  Create Dictionary
  ${response}  DELETE On Session    alias=${ALIAS_GLOBAL}  url=/accountservice/accountrest/api/v1/delete  json=${json_body}  headers=${headers}  expected_status=200

  Log To Console    message=${response.json()}
