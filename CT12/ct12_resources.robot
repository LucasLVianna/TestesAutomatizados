*** Settings ***
Documentation     CT12 - Impedir o cadastro de uma categoria já existente.
...               Fluxo: Categorias > Adicionar Categoria > preencher nome existente e descrição > Adicionar.
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

# Navegação
${MENU_CATEGORIAS}             id:categoriasButtonLink
${TITULO_CATEGORIAS}           Categorias de Produto
${BOTAO_ADICIONAR_CATEGORIA}   id:categoria_nova
${TITULO_NOVA_CATEGORIA}       Nova Categoria

# Formulário de categoria
${CAMPO_NOME_CATEGORIA}        id:nome_categoria
${CAMPO_DESCRICAO_CATEGORIA}   id:descricao_categoria
${BOTAO_ADICIONAR}             id:addcategoria
${CAMPO_ERRO}                  id:error
${CATEGORIA_EXISTENTE_LISTA}   xpath://table[contains(@class, 'tabela')]//tr[td][1]/td[3]
${MENSAGEM_DUPLICIDADE}        ERRO! Categoria já cadastrada.
${DESCRICAO_CATEGORIA}         ...


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
    Capture Page Screenshot    ${CURDIR}${/}ct12_01_login.png
    Click Element     ${BOTAO_ENTRAR}
    Wait Until Page Contains Element    ${ELEMENTO_POS_LOGIN}    timeout=${TIMEOUT}

Fechar o navegador
    Capture Page Screenshot    ${CURDIR}${/}ct12_05_fim.png
    Close Browser

# ---------------- CT12 ---------------
Acessar pagina de categorias
    Click Element                    ${MENU_CATEGORIAS}
    Wait Until Page Contains         ${TITULO_CATEGORIAS}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_CATEGORIA}    timeout=${TIMEOUT}
    Capture Page Screenshot    ${CURDIR}${/}ct12_02_categorias.png

Selecionar uma categoria ja cadastrada
    Wait Until Element Is Visible    ${CATEGORIA_EXISTENTE_LISTA}    timeout=${TIMEOUT}
    ...    error=Não há uma categoria cadastrada para executar o teste de duplicidade.
    ${nome_categoria}=    Get Text    ${CATEGORIA_EXISTENTE_LISTA}
    Should Not Be Empty    ${nome_categoria}
    Set Test Variable    ${CATEGORIA_DUPLICADA}    ${nome_categoria}
    Log    Categoria existente selecionada para o teste: ${CATEGORIA_DUPLICADA}

Clicar em adicionar categoria
    Click Element                    ${BOTAO_ADICIONAR_CATEGORIA}
    Wait Until Page Contains         ${TITULO_NOVA_CATEGORIA}    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${CAMPO_NOME_CATEGORIA}     timeout=${TIMEOUT}
    Capture Page Screenshot    ${CURDIR}${/}ct12_03_nova_categoria.png

Preencher os dados da categoria existente
    Input Text    ${CAMPO_NOME_CATEGORIA}        ${CATEGORIA_DUPLICADA}
    Input Text    ${CAMPO_DESCRICAO_CATEGORIA}   ${DESCRICAO_CATEGORIA}
    ${nome_digitado}=         Get Value    ${CAMPO_NOME_CATEGORIA}
    ${descricao_digitada}=    Get Value    ${CAMPO_DESCRICAO_CATEGORIA}
    Should Be Equal As Strings    ${nome_digitado}         ${CATEGORIA_DUPLICADA}
    Should Be Equal As Strings    ${descricao_digitada}    ${DESCRICAO_CATEGORIA}
    Capture Page Screenshot    ${CURDIR}${/}ct12_04_dados_duplicados.png

Clicar em adicionar
    Click Element    ${BOTAO_ADICIONAR}

O sistema impede o cadastro da categoria duplicada
    Wait Until Element Contains    ${CAMPO_ERRO}    ${MENSAGEM_DUPLICIDADE}    timeout=${TIMEOUT}
    ${mensagem}=    Get Text    ${CAMPO_ERRO}
    Should Be Equal As Strings    ${mensagem}    ${MENSAGEM_DUPLICIDADE}
    Capture Page Screenshot    ${CURDIR}${/}ct12_06_alerta_duplicidade.png
