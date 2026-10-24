*** Settings ***
Documentation     CT32 - Cadastrar produto com acentuação e cedilha no nome.
...               Fluxo: Produtos registrados > Adicionar > preencher > Salvar > conferir na lista.
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

# Produtos (CONFIRMAR no F12)
${MENU_PRODUTOS}            id:produtosButtonLink
${BOTAO_ADICIONAR_PRODUTO}  id:produto_novo
${CAMPO_NOME_PRODUTO}       id:nome_produto
${SELECT_CATEGORIA}         id:categoria_produto
${SELECT_UNIDADE}           id:und_medida_produto
${BOTAO_SALVAR_PRODUTO}     id:addproduto

# Dados do teste (CONFIRMAR os textos exatos das opções dos selects)
${NOME_PRODUTO_ACENTUADO}   Pão de Açúcar Orgânico
${CATEGORIA_PRODUTO}        Grãos e Cereais
${UNIDADE_PRODUTO}          Quilo (Kg)

# Conferência na lista
${NOME_NA_LISTA}            xpath://div[contains(@class, 'card-nome') and normalize-space()='${NOME_PRODUTO_ACENTUADO}']
${TEXTO_CORROMPIDO}         PÃ£o


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

# ---------------- CT32 ----------------
Abrir formulario de novo produto
    Click Element    ${MENU_PRODUTOS}
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_PRODUTO}    timeout=${TIMEOUT}
    Click Element    ${BOTAO_ADICIONAR_PRODUTO}
    Wait Until Element Is Visible    ${CAMPO_NOME_PRODUTO}    timeout=${TIMEOUT}

Cadastrar produto
    [Arguments]    ${nome}    ${categoria}    ${unidade}
    Input Text    ${CAMPO_NOME_PRODUTO}    ${nome}
    Select From List By Label    ${SELECT_CATEGORIA}    ${categoria}
    Select From List By Label    ${SELECT_UNIDADE}      ${unidade}
    Capture Page Screenshot
    Click Element    ${BOTAO_SALVAR_PRODUTO}
    Sleep    2s    # tempo para o cadastro ser processado

Produto deve aparecer na lista com o nome correto
    [Arguments]    ${nome}
    Click Element    ${MENU_PRODUTOS}
    Wait Until Element Is Visible    ${NOME_NA_LISTA}    timeout=${TIMEOUT}
    ...    error=O produto "${nome}" não aparece na lista exatamente como foi digitado.
    Scroll Element Into View    ${NOME_NA_LISTA}
    Capture Page Screenshot
    Page Should Not Contain    ${TEXTO_CORROMPIDO}
    ...    message=A acentuação foi corrompida na exibição (encontrado "${TEXTO_CORROMPIDO}").