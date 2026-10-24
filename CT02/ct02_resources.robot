*** Settings ***
Documentation     CT02 - Impedir cadastro com endereço de e-mail inválido.
...               Fluxo: página inicial > criar conta > preencher dados obrigatórios > validar e-mail inválido.
Library           SeleniumLibrary    run_on_failure=NONE


*** Variables ***
${BROWSER}                     Chrome
${URL_BASE}                    http://localhost/mykeeper
${TIMEOUT}                     10s

# Navegação e formulário
${BOTAO_COMECAR}               id:startNowButton
${BOTAO_CRIAR_CONTA}           id:createAccount
${CAMPO_NOME}                  id:nome
${CAMPO_EMAIL}                 id:email
${CAMPO_CEP}                   id:cep
${CAMPO_SENHA}                 id:senha
${BOTAO_CADASTRAR}             css:button[type="submit"]
${CAMPO_ERRO_EMAIL}            id:error-email
${CAMPO_ERRO_GERAL}            id:error

# Dados do teste: somente o endereço de e-mail é inválido
${NOME_VALIDO}                 Usuário Válido
${EMAIL_INVALIDO}              usuario.invalido.com
${CEP_VALIDO}                  81280080
${CEP_FORMATADO}               81280-080
${SENHA_VALIDA}                Teste12345678*
${MENSAGEM_EMAIL_INVALIDO}     ERRO! Digite um e-mail válido.


*** Keywords ***
Abrir o navegador
    Open Browser    ${URL_BASE}    ${BROWSER}
    Maximize Browser Window

Abrir o navegador e acessar cadastro
    Abrir o navegador
    Wait Until Element Is Visible    ${BOTAO_COMECAR}    timeout=${TIMEOUT}
    Capture Page Screenshot    ${CURDIR}${/}ct02_01_pagina_inicial.png
    Click Element    ${BOTAO_COMECAR}
    Wait Until Element Is Visible    ${BOTAO_CRIAR_CONTA}    timeout=${TIMEOUT}
    Capture Page Screenshot    ${CURDIR}${/}ct02_02_login.png
    Click Element    ${BOTAO_CRIAR_CONTA}
    Wait Until Element Is Visible    ${CAMPO_NOME}    timeout=${TIMEOUT}
    Capturar pagina completa    ${CURDIR}${/}ct02_03_formulario_cadastro.png

Preencher formulario com email invalido
    Input Text        ${CAMPO_NOME}     ${NOME_VALIDO}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_INVALIDO}
    Input Text        ${CAMPO_CEP}      ${CEP_VALIDO}
    Input Password    ${CAMPO_SENHA}    ${SENHA_VALIDA}
    Textfield Value Should Be    ${CAMPO_NOME}     ${NOME_VALIDO}
    Textfield Value Should Be    ${CAMPO_EMAIL}    ${EMAIL_INVALIDO}
    Textfield Value Should Be    ${CAMPO_CEP}      ${CEP_FORMATADO}
    Textfield Value Should Be    ${CAMPO_SENHA}    ${SENHA_VALIDA}
    Capturar pagina completa    ${CURDIR}${/}ct02_04_dados_invalidos.png

Clicar em cadastrar
    Click Element    ${BOTAO_CADASTRAR}

Validar mensagem solicitando email valido
    Wait Until Element Contains    ${CAMPO_ERRO_GERAL}    ${MENSAGEM_EMAIL_INVALIDO}    timeout=${TIMEOUT}
    ${mensagem}=    Get Text    ${CAMPO_ERRO_GERAL}
    Should Be Equal As Strings    ${mensagem}    ${MENSAGEM_EMAIL_INVALIDO}
    ...    A mensagem de validação do e-mail está diferente da esperada.
    Capturar pagina completa    ${CURDIR}${/}ct02_05_validacao_email.png
    Capturar pagina completa    ${CURDIR}${/}ct02_06_fim.png

Capturar pagina completa
    [Arguments]    ${arquivo}
    Execute Javascript    window.scrollTo(0, 0); document.documentElement.style.zoom = '65%'
    Capture Page Screenshot    ${arquivo}
    Execute Javascript    document.documentElement.style.zoom = '100%'

Fechar o navegador
    Close Browser