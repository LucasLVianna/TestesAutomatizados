*** Settings ***
Documentation     CT25 - Filtrar produtos por nome. Pré-condição: produtos com e sem "Queijo" no nome cadastrados.
Resource          ct25_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT25 - Filtrar produtos por nome na adição de itens ao estoque
    [Documentation]    A listagem deve exibir exclusivamente produtos com "Queijo" no nome.
    [Tags]    estoque    funcionalidade    caixa_preta
    Abrir formulario de novo item no estoque 
    Filtrar produtos por nome    ${TERMO_FILTRO}
    Todos os produtos listados devem conter    ${TERMO_FILTRO}