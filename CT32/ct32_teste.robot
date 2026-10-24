*** Settings ***
Documentation     CT32 - Acentuação e cedilha. Pré-condição: categoria "Grãos" e unidade "Quilo (Kg)" cadastradas.
Resource          ct32_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT32 - Cadastrar produto com acentuação e cedilha no nome
    [Documentation]    O nome deve ser exibido na listagem exatamente como digitado.
    [Tags]    produtos    funcionalidade    caixa_preta
    Abrir formulario de novo produto
    Cadastrar produto    ${NOME_PRODUTO_ACENTUADO}    ${CATEGORIA_PRODUTO}    ${UNIDADE_PRODUTO}
    Click Element    ${MENU_PRODUTOS}
    Wait Until Page Contains    ${NOME_PRODUTO_ACENTUADO}    timeout=${TIMEOUT}
    Page Should Not Contain    PÃ£o
