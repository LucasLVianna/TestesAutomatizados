*** Settings ***
Documentation     CT26 - Validade retroativa.
...               Pré-condição: produto "Iogurte Natural" cadastrado e estoque "Geladeira Principal" existente.
Resource          ct26_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT26 - Inserir item com data de validade vencida
    [Documentation]    O sistema deve avisar que o produto já está vencido.
    ...                Resultado atual registrado na planilha: NOK (o aviso não é exibido).
    [Tags]    estoque    funcionalidade    caixa_preta
    Abrir formulario de novo item no estoque
    Filtrar produtos por nome    ${TERMO_FILTRO}
    ${ontem}=    Preencher item com validade vencida    ${QUANTIDADE_ITEM}
    Sistema deve avisar que o produto esta vencido    ${ontem}