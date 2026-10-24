*** Settings ***
Documentation     CT27 - Abrir ticket de suporte sem descrição.
...               Fluxo: Tickets > Adicionar Ticket > preencher só o título > Criar Ticket.
Library           SeleniumLibrary    run_on_failure=NONE


*** Variables ***
${BROWSER}                  Chrome
${URL_BASE}                 http://localhost/mykeeper
${URL_LOGIN}                ${URL_BASE}/usuario_login
${USUARIO_VALIDO}           teste@teste.com
${SENHA_VALIDA}             Teste12345*
${TIMEOUT}                  10s

# Login
${CAMPO_LOGIN_USUARIO}      id:email
${CAMPO_LOGIN_SENHA}        id:senha
${BOTAO_ENTRAR}             css:button[type="submit"]
${ELEMENTO_POS_LOGIN}       id:logoffButtonLink

# Tickets 
${MENU_TICKETS}             id:ticketButtonLink
${BOTAO_ADICIONAR_TICKET}   id:ticket_novo
${CAMPO_TITULO_TICKET}      id:titulo
${CAMPO_DESCRICAO_TICKET}   id:descricao
${BOTAO_CRIAR_TICKET}       id:criarTicket

# Dados do teste
${TITULO_TICKET}            Dúvida de uso
${MSG_DESCRICAO_OBRIG}      Por favor, preencha a descrição do ticket


*** Keywords ***
Abrir o navegador e fazer login
    Open Browser    ${URL_LOGIN}    ${BROWSER}
    Maximize Browser Window
    Realizar login    ${USUARIO_VALIDO}    ${SENHA_VALIDA}

Realizar login
    [Arguments]    ${usuario}    ${senha}
    Wait Until Element Is Visible    ${CAMPO_LOGIN_USUARIO}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_LOGIN_USUARIO}    ${usuario}
    Input Password    ${CAMPO_LOGIN_SENHA}      ${senha}
    Capture Page Screenshot
    Click Element     ${BOTAO_ENTRAR}
    Wait Until Page Contains Element    ${ELEMENTO_POS_LOGIN}    timeout=${TIMEOUT}

Fechar o navegador
    Capture Page Screenshot
    Close Browser

# ---------------- CT27 ----------------
Abrir formulario de novo ticket
    Click Element    ${MENU_TICKETS}
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_TICKET}    timeout=${TIMEOUT}
    Click Element    ${BOTAO_ADICIONAR_TICKET}
    Wait Until Element Is Visible    ${CAMPO_TITULO_TICKET}    timeout=${TIMEOUT}

Preencher ticket sem descricao
    [Arguments]    ${titulo}
    Input Text    ${CAMPO_TITULO_TICKET}    ${titulo}
    Clear Element Text    ${CAMPO_DESCRICAO_TICKET}
    Capture Page Screenshot
    Click Element    ${BOTAO_CRIAR_TICKET}
    Sleep    1s    # tempo para a validação aparecer
    Capture Page Screenshot

Campo deve exibir mensagem de obrigatoriedade
    [Documentation]    Aceita a mensagem exibida na página ou a validação nativa
    ...                do HTML (atributo required), que não aparece no DOM.
    [Arguments]    ${locator_campo}    ${mensagem_esperada}
    # Mensagem do próprio sistema na página
    ${na_pagina}=    Run Keyword And Return Status
    ...    Wait Until Page Contains    ${mensagem_esperada}    timeout=3s
    IF    ${na_pagina}    RETURN
    # Validação nativa do navegador 
    ${campo}=    Get WebElement    ${locator_campo}
    ${msg_nativa}=    Execute JavaScript    return arguments[0].validationMessage;    ARGUMENTS    ${campo}
    Log    Mensagem nativa do navegador: ${msg_nativa}
    Should Not Be Empty    ${msg_nativa}
    ...    O envio não foi bloqueado: nenhuma mensagem de campo obrigatório foi exibida.
    # Garante que o formulário não foi enviado
    Element Should Be Visible    ${CAMPO_TITULO_TICKET}
    ...    O formulário foi enviado mesmo sem a descrição.