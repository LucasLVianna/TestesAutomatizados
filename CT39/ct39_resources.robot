*** Settings ***
Documentation     CT39 - Alterar o nome de uma categoria cadastrada.
...               Fluxo: Categorias > editar "Laticínios" > alterar nome para "Frios" > Alterar.
Library           SeleniumLibrary    run_on_failure=NONE


*** Variables ***
${BROWSER}                     Chrome
${URL_BASE}                    http://localhost/mykeeper
${URL_LOGIN}                   ${URL_BASE}/usuario_login
${USUARIO_VALIDO}              user@user.com
${SENHA_VALIDA}                 Teste12345*
${TIMEOUT}                     10s

# Login
${CAMPO_LOGIN_USUARIO}         id:email
${CAMPO_LOGIN_SENHA}           id:senha
${BOTAO_ENTRAR}                css:button[type="submit"]
${ELEMENTO_POS_LOGIN}          id:logoffButtonLink

# Categorias
${MENU_CATEGORIAS}             id:categoriasButtonLink
${TITULO_CATEGORIAS}           Categorias de Produto
${NOME_CATEGORIA_ORIGINAL}     Laticínios
${NOME_CATEGORIA_ALTERADO}     Frios
${CATEGORIA_ORIGINAL_LISTA}    xpath://table[contains(@class, 'tabela')]//tr[td][td[3][normalize-space()='${NOME_CATEGORIA_ORIGINAL}']]
${LINK_EDITAR_CATEGORIA}       xpath://table[contains(@class, 'tabela')]//tr[td][td[3][normalize-space()='${NOME_CATEGORIA_ORIGINAL}']]//a[normalize-space()='Editar']
${CATEGORIA_ALTERADA_LISTA}    xpath://table[contains(@class, 'tabela')]//tr[td][td[3][normalize-space()='${NOME_CATEGORIA_ALTERADO}']]

# Formulário de alteração
${TITULO_ALTERAR_CATEGORIA}    Alterar Categoria
${CAMPO_NOME_CATEGORIA}        id:nome_categoria
${BOTAO_ALTERAR}               id:alterarcategoria
${MENSAGEM_SUCESSO}            SUCESSO! Categoria alterada com sucesso. Redirecionando...


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
    Capture Page Screenshot    ${CURDIR}${/}ct39_01_login.png
    Click Element     ${BOTAO_ENTRAR}
    Wait Until Page Contains Element    ${ELEMENTO_POS_LOGIN}    timeout=${TIMEOUT}

Fechar o navegador
    Capture Page Screenshot    ${CURDIR}${/}ct39_06_fim.png
    Close Browser

# ---------------- CT39 ----------------
Acessar pagina de categorias
    Click Element                    ${MENU_CATEGORIAS}
    Wait Until Page Contains         ${TITULO_CATEGORIAS}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${LINK_EDITAR_CATEGORIA}    timeout=${TIMEOUT}
    Capture Page Screenshot    ${CURDIR}${/}ct39_02_categoria_laticinios.png

Clicar em editar na categoria Laticinios
    Click Element                    ${LINK_EDITAR_CATEGORIA}
    Wait Until Page Contains         ${TITULO_ALTERAR_CATEGORIA}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${CAMPO_NOME_CATEGORIA}         timeout=${TIMEOUT}
    Wait Until Keyword Succeeds      ${TIMEOUT}    500ms    Textfield Value Should Be    ${CAMPO_NOME_CATEGORIA}    ${NOME_CATEGORIA_ORIGINAL}
    Capture Page Screenshot    ${CURDIR}${/}ct39_03_editar_categoria.png

Alterar o nome da categoria para Frios
    Clear Element Text    ${CAMPO_NOME_CATEGORIA}
    Input Text            ${CAMPO_NOME_CATEGORIA}    ${NOME_CATEGORIA_ALTERADO}
    Textfield Value Should Be    ${CAMPO_NOME_CATEGORIA}    ${NOME_CATEGORIA_ALTERADO}
    Capture Page Screenshot    ${CURDIR}${/}ct39_04_nome_alterado.png

Clicar em alterar
    Click Element    ${BOTAO_ALTERAR}

O sistema confirma a alteracao e atualiza a categoria na lista
    Wait Until Element Contains    id:error    ${MENSAGEM_SUCESSO}    timeout=${TIMEOUT}
    Capture Page Screenshot    ${CURDIR}${/}ct39_05_sucesso.png
    Wait Until Page Contains    ${TITULO_CATEGORIAS}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${CATEGORIA_ALTERADA_LISTA}    timeout=${TIMEOUT}
    Page Should Not Contain Element    ${CATEGORIA_ORIGINAL_LISTA}
    Capture Page Screenshot    ${CURDIR}${/}ct39_06_categoria_frios.png