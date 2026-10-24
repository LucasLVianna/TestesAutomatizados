*** Settings ***
Documentation     CT26 - Inserir item com data de validade vencida.
...               Fluxo: Estoques > clicar em um estoque > Novo Item > buscar produto
...               > preencher quantidade e validade (ontem) > + ADICIONAR.
Library           SeleniumLibrary    run_on_failure=NONE
Library           DateTime
Library           String


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

# Navegação até "Adicionar Item"
${MENU_ESTOQUES}            id:estoquesButtonLink
${ESTOQUE_ALVO}             Geladeira Principal
${CARD_ESTOQUE}             xpath://div[contains(@class, 'card-nome') and normalize-space()='${ESTOQUE_ALVO}']
${TITULO_ITENS_ESTOQUE}     Itens do Estoque
${BOTAO_NOVO_ITEM}          id:adicionarItem
${TITULO_ADICIONAR_ITEM}    Adicionar Item

# Busca de produtos
${CAMPO_FILTRO_PRODUTO}     id:buscar-produto
${TERMO_FILTRO}             Iogurte
${PRODUTO_ALVO}             Iogurte Natural
${QUANTIDADE_ITEM}          1

# Card do produto alvo e campos dentro dele
${XP_CARD_PRODUTO}          //div[@id='item']/div[contains(@class, 'card') and .//div[contains(@class, 'card-nome') and normalize-space()='${PRODUTO_ALVO}']]
${CARD_PRODUTO}             xpath:${XP_CARD_PRODUTO}
${CAMPO_QUANTIDADE_ITEM}    xpath:${XP_CARD_PRODUTO}//input[starts-with(@id, 'quantidade-')]
${CAMPO_VALIDADE_ITEM}      xpath:${XP_CARD_PRODUTO}//input[starts-with(@id, 'validade-')]
${BOTAO_ADICIONAR_ITEM}     xpath:${XP_CARD_PRODUTO}//div[contains(@class, 'card-botoes')]//button[contains(@onclick, 'adicionar')]

# Aviso esperado (aceita "vencido", "Vencido", "vencida"...)
${TERMO_AVISO}              vencid
${AVISO_VENCIDO_PAGINA}     xpath://*[contains(translate(normalize-space(text()), 'VENCIDA', 'vencida'), '${TERMO_AVISO}')]


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

# ---------------- CT26 ----------------
Abrir formulario de novo item no estoque
    Click Element    ${MENU_ESTOQUES}
    Wait Until Element Is Visible    ${CARD_ESTOQUE}    timeout=${TIMEOUT}
    Click Element    ${CARD_ESTOQUE}
    Wait Until Page Contains    ${TITULO_ITENS_ESTOQUE}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${BOTAO_NOVO_ITEM}    timeout=${TIMEOUT}
    Click Element    ${BOTAO_NOVO_ITEM}
    Wait Until Page Contains    ${TITULO_ADICIONAR_ITEM}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${CAMPO_FILTRO_PRODUTO}    timeout=${TIMEOUT}

Filtrar produtos por nome
    [Arguments]    ${termo}
    Input Text    ${CAMPO_FILTRO_PRODUTO}    ${termo}
    Sleep    1s    # tempo para o filtro atualizar a listagem
    Wait Until Element Is Visible    ${CARD_PRODUTO}    timeout=${TIMEOUT}

Data de ontem no formato do campo
    ${ontem}=    Get Current Date    increment=-1 day    result_format=%Y-%m-%d
    RETURN    ${ontem}

Preencher campo de data
    [Arguments]    ${locator}    ${data_iso}
    ${campo}=    Get WebElement    ${locator}
    Execute JavaScript
    ...    arguments[0].value = arguments[1];
    ...    arguments[0].dispatchEvent(new Event('input', {bubbles: true}));
    ...    arguments[0].dispatchEvent(new Event('change', {bubbles: true}));
    ...    ARGUMENTS    ${campo}    ${data_iso}

Preencher item com validade vencida
    [Arguments]    ${quantidade}
    Input Text    ${CAMPO_QUANTIDADE_ITEM}    ${quantidade}
    ${ontem}=    Data de ontem no formato do campo
    Preencher campo de data    ${CAMPO_VALIDADE_ITEM}    ${ontem}
    Click Element    ${BOTAO_ADICIONAR_ITEM}
    Sleep    2s
    Capture Page Screenshot
    RETURN    ${ontem}

Sistema deve avisar que o produto esta vencido
    [Arguments]    ${data}
    # Aviso como alerta do navegador ou na própria tela
    ${status}    ${mensagem}=    Run Keyword And Ignore Error    Handle Alert    action=ACCEPT    timeout=3s
    IF    '${status}' == 'PASS'
        ${mensagem_min}=    Convert To Lower Case    ${mensagem}
        Should Contain    ${mensagem_min}    ${TERMO_AVISO}
        ...    O alerta exibido não fala de validade vencida: ${mensagem}
        RETURN
    END
    Wait Until Page Contains Element    ${AVISO_VENCIDO_PAGINA}    timeout=${TIMEOUT}
    ...    error=O sistema não avisou que a validade informada (${data}) já passou.