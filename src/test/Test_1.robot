*** Settings ***
Resource  ../resource/account_service/ky_account_service.robot
Resource  ../resource/order/ky_order.robot

Suite Setup  Given Que estou autenticado    user=${user_gesmachado}
Suite Teardown  And Eu faço o logout    user=${user_gesmachado}

*** Variables ***

*** Test Cases ***
Teste 1 - Adicionar Produto no carrinho
  When Eu adiciono um produto no carrinho    user=${user_gesmachado}    product_id=10    color=C3C3C3    warranty=false    quantity=1
  Then Eu confiro o produto no carrinho    user=${user_gesmachado}
  And Eu limpo o carrinho do cliente    user=${user_gesmachado}

*** Keywords ***


# Criar uma nova conta de usuário
# Efetuar o Login do usuário
#
# Adicionar um produto no carrinho,
# Efetuar o Logout
#
# outro cenário qualquer a sua escolha
