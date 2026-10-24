*** Settings ***
Documentation     CT31 - Logoff impede acesso a página protegida.
...               Fluxo: login > Estoques (guarda a URL) > Sair > acessar a URL guardada.
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

# Página protegida e logoff
${MENU_ESTOQUES}            id:estoquesButtonLink
${TITULO_PAGINA_PROTEGIDA}  Estoque
${BOTAO_SAIR}               id:logoffButtonLink
${START_BOTAO}              id:startNowButton


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

# ---------------- CT31 ----------------
Guardar URL da pagina protegida
    Click Element    ${MENU_ESTOQUES}
    Wait Until Page Contains    ${TITULO_PAGINA_PROTEGIDA}    timeout=${TIMEOUT}
    ${url}=    Get Location
    Log    URL protegida: ${url}
    Capture Page Screenshot
    RETURN    ${url}

Fazer logoff
    Click Element    ${BOTAO_SAIR}
    Wait Until Element Is Visible    ${START_BOTAO}    timeout=${TIMEOUT}
    ...    error=Após clicar em Sair, o sistema não voltou para a página principal.
    Capture Page Screenshot

Acesso a pagina protegida deve ser bloqueado
    [Arguments]    ${url}
    Go To    ${url}
    Wait Until Element Is Visible    ${CAMPO_LOGIN_USUARIO}    timeout=${TIMEOUT}
    ...    error=Página protegida (${url}) acessível após o logoff: a sessão não foi encerrada.
    Page Should Not Contain Element    ${BOTAO_SAIR}
    ...    message=O menu do usuário logado continua visível após o logoff.
    ${url_atual}=    Get Location
    Log    Após acessar a URL protegida, o sistema redirecionou para: ${url_atual}