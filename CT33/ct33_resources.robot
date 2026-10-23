*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ---------- Ambiente ----------
${BROWSER}                     Chrome
${URL}                         http://localhost/mykeeper
${HEADLESS}                    False
${TIMEOUT}                     10s

# ---------- Massa de dados ----------
${NOME_USUARIO}                Usuario Teste CT33
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${NOVA_SENHA}                  NovaSenha@456
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
${BOTAO_COMECAR_AGORA}         id:startNowButton

# ---------- Perfil / Senha  ----------
${MENU_PERFIL}                 id:perfilButtonLink
${LINK_MUDAR_SENHA}            id:linkSenha
${CAMPO_SENHA_ATUAL}           id:senha
${CAMPO_NOVA_SENHA}            id:nova_senha
${BOTAO_SALVAR_SENHA}          id:alterarsenha
${MSG_SENHA_ATUAL_INCORRETA}   Senha atual incorreta

*** Keywords ***
# ---------- Navegador ----------
Abrir o navegador
    ${opcoes}=    Montar opcoes do navegador
    Open Browser    ${URL}    ${BROWSER}    options=${opcoes}
    Maximize Browser Window

Montar opcoes do navegador
    ${opcoes}=    Set Variable    add_argument("--window-size=1920,1080")
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
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct33@teste.com
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

# ---------- Login / Logout ----------
Tentar efetuar login
    [Arguments]    ${senha}
    Go To    url=${URL}/usuario_login
    Wait Until Element Is Visible    ${CAMPO_EMAIL}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_USUARIO}
    Input Password    ${CAMPO_SENHA}    ${senha}
    Click Button      ${BOTAO_ENTRAR}

Verificar que o login foi realizado
    Wait Until Location Contains    /home    timeout=${TIMEOUT}
    Wait Until Element Is Visible   ${MENU_SAIR}    timeout=${TIMEOUT}

Verificar que o login foi recusado
    Wait Until Element Contains    ${MENSAGEM_FORMULARIO}    ${MSG_LOGIN_INVALIDO}    timeout=${TIMEOUT}
    Location Should Contain        usuario_login

Efetuar login no MyKeeper
    [Arguments]    ${senha}
    Tentar efetuar login    ${senha}
    Verificar que o login foi realizado

Efetuar logout
    # A tela Alterar Senha nao exibe o menu lateral, volta para a home antes de sair
    Go To    url=${URL}/home
    Wait Until Element Is Visible    ${MENU_SAIR}    timeout=${TIMEOUT}
    Click Button    ${MENU_SAIR}
    Wait Until Element Is Visible    ${BOTAO_COMECAR_AGORA}    timeout=${TIMEOUT}

# ---------- Perfil / Senha ----------
Acessar a tela de mudar senha
    Click Button    ${MENU_PERFIL}
    Wait Until Element Is Visible    ${LINK_MUDAR_SENHA}    timeout=${TIMEOUT}
    Click Element    ${LINK_MUDAR_SENHA}
    Wait Until Element Is Visible    ${CAMPO_NOVA_SENHA}    timeout=${TIMEOUT}

Preencher a alteracao de senha
    [Arguments]    ${senha_atual}    ${nova_senha}
    Input Password    ${CAMPO_SENHA_ATUAL}    ${senha_atual}
    Input Password    ${CAMPO_NOVA_SENHA}     ${nova_senha}
    Click Button      ${BOTAO_SALVAR_SENHA}

Verificar mensagem de senha atual incorreta
    Wait Until Element Contains    ${MENSAGEM_FORMULARIO}    ${MSG_SENHA_ATUAL_INCORRETA}    timeout=${TIMEOUT}
    Location Should Contain    senha_alterar
