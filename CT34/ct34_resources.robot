*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ---------- Ambiente ----------
${BROWSER}                     Chrome
${CAMINHO_BRAVE}              C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe
${URL}                         http://localhost/mykeeper
${HEADLESS}                    False
${TIMEOUT}                     10s

# ---------- Massa de dados ----------
${NOME_USUARIO}                Usuario Teste CT34
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${SENHA_INCORRETA}             SenhaErrada@789

# ---------- Cadastro / Login / Logout ----------
${CAMPO_NOME}                  id:nome
${CAMPO_EMAIL}                 id:email
${CAMPO_CEP}                   id:cep
${CAMPO_SENHA}                 id:senha
${BOTAO_CRIAR_CONTA}           css:#formCadastro button[type=submit]
${BOTAO_ENTRAR}                css:#formLogin button[type=submit]
${MENSAGEM_FORMULARIO}         id:error
${MSG_CADASTRO_SUCESSO}        Cadastro realizado com êxito
${MSG_LOGIN_INVALIDO}          Email ou senha incorretos
${MENU_SAIR}                   id:logoffButtonLink

*** Keywords ***
# ---------- Navegador ----------
Abrir o navegador
    ${opcoes}=    Montar opcoes do navegador
    Open Browser    ${URL}    ${BROWSER}    options=${opcoes}
    Maximize Browser Window

Montar opcoes do navegador
    ${opcoes}=    Set Variable    add_argument("--window-size=1920,1080");binary_location="${CAMINHO_BRAVE}"
    IF    $HEADLESS.lower() == 'true'
        ${opcoes}=    Set Variable    ${opcoes};add_argument("--headless=new")
    END
    RETURN    ${opcoes}

Fechar o navegador
    Capture Page Screenshot
    Close Browser

# ---------- Massa de dados ----------
Preparar massa de dados do caso
    ${id_execucao}=    Evaluate    str(time.time_ns())    modules=time
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct34@teste.com
    Abrir o navegador
    Cadastrar usuario de teste
    Close Browser

Cadastrar usuario de teste
    Go To    url=${URL}/usuario_cadastro
    Wait Until Element Is Visible    ${CAMPO_NOME}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_NOME}     ${NOME_USUARIO}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_USUARIO}
    Input Text        ${CAMPO_CEP}      ${CEP_USUARIO}
    Input Password    ${CAMPO_SENHA}    ${SENHA_PADRAO}
    Click Button      ${BOTAO_CRIAR_CONTA}
    Wait Until Element Contains     ${MENSAGEM_FORMULARIO}    ${MSG_CADASTRO_SUCESSO}    timeout=${TIMEOUT}
    Wait Until Location Contains    usuario_login             timeout=${TIMEOUT}

# ---------- Login ----------
Tentar efetuar login
    [Arguments]    ${senha}
    Go To    url=${URL}/usuario_login
    Wait Until Element Is Visible    ${CAMPO_EMAIL}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_USUARIO}
    Input Password    ${CAMPO_SENHA}    ${senha}
    Click Button      ${BOTAO_ENTRAR}

Verificar que o login foi recusado
    Wait Until Element Contains    ${MENSAGEM_FORMULARIO}    ${MSG_LOGIN_INVALIDO}    timeout=${TIMEOUT}
    Location Should Contain        usuario_login
    Page Should Not Contain Element    ${MENU_SAIR}
