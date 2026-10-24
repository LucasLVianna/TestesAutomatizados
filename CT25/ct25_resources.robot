*** Settings ***
Documentation     CT25 - Filtrar produtos por nome na adição de itens ao estoque.
...               Fluxo: Estoques > clicar em um estoque > Novo Item > Buscar produto.
Library           SeleniumLibrary
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
${CARDS_PRODUTO}            css:#item .card-nome
${TERMO_FILTRO}             Queijo


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

# ---------------- CT25 ----------------
Abrir formulario de novo item no estoque
    Click Element    ${MENU_ESTOQUES}
    Wait Until Element Is Visible    ${CARD_ESTOQUE}    timeout=${TIMEOUT}
    Click Element    ${CARD_ESTOQUE}
    Wait Until Page Contains    ${TITULO_ITENS_ESTOQUE}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${BOTAO_NOVO_ITEM}    timeout=${TIMEOUT}
    Click Element    ${BOTAO_NOVO_ITEM}
    Wait Until Page Contains    ${TITULO_ADICIONAR_ITEM}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${CAMPO_FILTRO_PRODUTO}    timeout=${TIMEOUT}
    Capture Page Screenshot   

Filtrar produtos por nome
    [Arguments]    ${termo}
    Input Text    ${CAMPO_FILTRO_PRODUTO}    ${termo}
    Sleep    1s    # tempo para o filtro atualizar a listagem

Todos os produtos listados devem conter
    [Arguments]    ${termo}
    ${cards}=    Get WebElements    ${CARDS_PRODUTO}
    Should Not Be Empty    ${cards}    Nenhum produto foi exibido após o filtro.
    ${termo_min}=    Convert To Lower Case    ${termo}
    ${exibidos}=    Set Variable    ${0}
    FOR    ${card}    IN    @{cards}
        ${visivel}=    Call Method    ${card}    is_displayed
        IF    not ${visivel}    CONTINUE
        ${texto}=    Get Text    ${card}
        ${texto_min}=    Convert To Lower Case    ${texto}
        Should Contain    ${texto_min}    ${termo_min}    Produto fora do filtro exibido: ${texto}
        ${exibidos}=    Evaluate    ${exibidos} + 1
    END
    Should Be True    ${exibidos} > 0    Nenhum produto visível após o filtro.