*** Settings ***
Documentation     CT27 - Ticket de suporte sem descrição.
Resource          ct27_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT27 - Abrir ticket de suporte sem descrição
    [Documentation]    O envio deve ser bloqueado, exigindo o preenchimento da descrição.
    [Tags]    suporte    funcionalidade    caixa_preta
    Abrir formulario de novo ticket
    Input Text    ${CAMPO_TITULO_TICKET}    Dúvida de uso
    Clear Element Text    ${CAMPO_DESCRICAO_TICKET}
    Click Element    ${BOTAO_CRIAR_TICKET}
    Campo deve exibir mensagem de obrigatoriedade    ${CAMPO_DESCRICAO_TICKET}    ${MSG_DESCRICAO_OBRIG}
