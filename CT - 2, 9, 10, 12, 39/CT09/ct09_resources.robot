*** Settings ***
Documentation     CT09 - Impedir inserção de item com quantidade negativa no estoque.
...               Fluxo: Estoques > clicar em um estoque ("Itens do Estoque") > "Novo Item"
...               > escolher produto pré-cadastrado > informar Quantidade = -1 > "+ Adicionar"
...               > sistema impede o salvamento exibindo alerta "A quantidade deve ser maior do que 0".
Library           SeleniumLibrary    run_on_failure=NONE
Library           String


*** Variables ***
${BROWSER}                     Chrome
${URL_BASE}                    http://localhost/mykeeper
${URL_LOGIN}                   ${URL_BASE}/usuario_login
${USUARIO_VALIDO}              user@user.com
${SENHA_VALIDA}                Teste12345*
${TIMEOUT}                     10s

# Login
${CAMPO_LOGIN_USUARIO}         id:email
${CAMPO_LOGIN_SENHA}           id:senha
${BOTAO_ENTRAR}                css:button[type="submit"]
${ELEMENTO_POS_LOGIN}          id:logoffButtonLink

# Navegação
${MENU_ESTOQUES}               id:estoquesButtonLink
${ESTOQUE_ALVO}                Despensa
${CARD_ESTOQUE}                xpath://div[contains(@class, 'card-nome') and normalize-space()='${ESTOQUE_ALVO}']
${TITULO_ITENS_ESTOQUE}        Itens do Estoque
${BOTAO_NOVO_ITEM}             id:adicionarItem
${TITULO_ADICIONAR_ITEM}       Adicionar Item

# Busca e seleção de produtos
${CAMPO_FILTRO_PRODUTO}        id:buscar-produto
${PRODUTO_ALVO}                Arroz
${QUANTIDADE_INVALIDA}         -1

# Card do produto alvo e campos dentro dele
${XP_CARD_PRODUTO}             //div[@id='item']/div[contains(@class, 'card') and .//div[contains(@class, 'card-nome') and normalize-space()='${PRODUTO_ALVO}']]
${CARD_PRODUTO}                xpath:${XP_CARD_PRODUTO}
${CAMPO_QUANTIDADE_ITEM}       xpath:${XP_CARD_PRODUTO}//input[starts-with(@id, 'quantidade-')]
${BOTAO_ADICIONAR_ITEM}        xpath:${XP_CARD_PRODUTO}//div[contains(@class, 'card-botoes')]//button[contains(@onclick, 'adicionar')]

# Aviso esperado
${TERMO_AVISO}                 maior do que 0
${AVISO_QUANTIDADE_PAGINA}     xpath://*[contains(translate(normalize-space(text()), 'MAIOR DO QUE 0', 'maior do que 0'), '${TERMO_AVISO}')]


*** Keywords ***
Abrir o navegador
    Open Browser    ${URL_LOGIN}    ${BROWSER}
    Maximize Browser Window

Abrir o navegador e fazer login
    Abrir o navegador
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

# ---------------- CT9 ----------------
Acessar pagina de itens do estoque
    Click Element                    ${MENU_ESTOQUES}
    Wait Until Element Is Visible    ${CARD_ESTOQUE}            timeout=${TIMEOUT}
    Click Element                    ${CARD_ESTOQUE}
    Wait Until Page Contains         ${TITULO_ITENS_ESTOQUE}    timeout=${TIMEOUT}
    Capture Page Screenshot

Clicar em novo item
    Wait Until Element Is Visible    ${BOTAO_NOVO_ITEM}         timeout=${TIMEOUT}
    Click Element                    ${BOTAO_NOVO_ITEM}
    Wait Until Page Contains         ${TITULO_ADICIONAR_ITEM}   timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${CAMPO_FILTRO_PRODUTO}    timeout=${TIMEOUT}
    Capture Page Screenshot

Escolher um produto pre-cadastrado
    [Arguments]    ${nome_produto}=${PRODUTO_ALVO}
    Input Text                       ${CAMPO_FILTRO_PRODUTO}    ${nome_produto}
    Sleep                            1s    # tempo para o filtro atualizar a listagem
    Wait Until Element Is Visible    ${CARD_PRODUTO}            timeout=${TIMEOUT}
    Capture Page Screenshot

Informar quantidade do item
    [Arguments]    ${quantidade}=${QUANTIDADE_INVALIDA}
    Wait Until Element Is Visible    ${CAMPO_QUANTIDADE_ITEM}    timeout=${TIMEOUT}
    Clear Element Text               ${CAMPO_QUANTIDADE_ITEM}
    Input Text                       ${CAMPO_QUANTIDADE_ITEM}    ${quantidade}
    ${valor_digitado}=               Get Value                   ${CAMPO_QUANTIDADE_ITEM}
    Should Be Equal As Strings       ${valor_digitado}           ${quantidade}
    ...    msg=O sistema não aceitou a quantidade digitada (${quantidade}). Valor atual: ${valor_digitado}
    Capture Page Screenshot

Clicar em adicionar item
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_ITEM}    timeout=${TIMEOUT}
    Click Element                    ${BOTAO_ADICIONAR_ITEM}
    Sleep                            1s

O sistema impede o salvamento exibindo alerta "A quantidade deve ser maior do que 0"
    # Aviso como alerta do navegador ou na própria tela
    ${status}    ${mensagem}=    Run Keyword And Ignore Error    Handle Alert    action=ACCEPT    timeout=3s
    IF    '${status}' == 'PASS'
        Log    Texto do alerta do navegador: ${mensagem}
        Capture Page Screenshot
        ${mensagem_min}=    Convert To Lower Case    ${mensagem}
        Should Contain    ${mensagem_min}    ${TERMO_AVISO}
        ...    O alerta exibido não fala que a quantidade deve ser maior do que 0: ${mensagem}
        RETURN
    END
    Wait Until Page Contains Element    ${AVISO_QUANTIDADE_PAGINA}    timeout=${TIMEOUT}
    ...    error=O sistema não avisou que a quantidade deve ser maior do que 0.
    Capture Page Screenshot
