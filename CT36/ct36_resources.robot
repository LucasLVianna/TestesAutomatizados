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
${NOME_USUARIO}                Usuario Teste CT36
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${NOME_LISTA}                  Lista CT36

# ---------- Cadastro / Login ----------
${CAMPO_NOME}                  id:nome
${CAMPO_EMAIL}                 id:email
${CAMPO_CEP}                   id:cep
${CAMPO_SENHA}                 id:senha
${BOTAO_CRIAR_CONTA}           css:#formCadastro button[type=submit]
${BOTAO_ENTRAR}                css:#formLogin button[type=submit]
${MENSAGEM_FORMULARIO}         id:error
${MSG_CADASTRO_SUCESSO}        Cadastro realizado com êxito
${MENU_SAIR}                   id:logoffButtonLink

# ---------- Lista de Compras ----------
${BOTAO_ADICIONAR_LISTA}       id:criarCompras
${CAMPO_TITULO_LISTA}          id:titulo
${BOTAO_SALVAR_LISTA}          id:addcompras
${CARD_LISTA}                  xpath://div[contains(@class,'card')][.//p[contains(@class,'card-nome')][normalize-space()='${NOME_LISTA}']]
${BOTAO_ARQUIVAR_LISTA}        ${CARD_LISTA}//button[contains(@class,'btn-arquivar')]
${BADGE_STATUS_LISTA}          ${CARD_LISTA}//*[contains(@class,'badge-status')]
${BOTAO_CONFIRMAR}             css:.notificacao-confirmar

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
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct36@teste.com
    Abrir o navegador
    Cadastrar usuario de teste
    Efetuar login no MyKeeper
    Cadastrar lista de compras
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

Cadastrar lista de compras
    Acessar a pagina de listas de compras
    Click Button    ${BOTAO_ADICIONAR_LISTA}
    Wait Until Element Is Visible    ${CAMPO_TITULO_LISTA}    timeout=${TIMEOUT}
    Input Text      ${CAMPO_TITULO_LISTA}    ${NOME_LISTA}
    Click Button    ${BOTAO_SALVAR_LISTA}
    Wait Until Location Does Not Contain    compras_novo    timeout=${TIMEOUT}
    Wait Until Page Contains    ${NOME_LISTA}    timeout=${TIMEOUT}

# ---------- Login ----------
Efetuar login no MyKeeper
    Go To    url=${URL}/usuario_login
    Wait Until Element Is Visible    ${CAMPO_EMAIL}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_USUARIO}
    Input Password    ${CAMPO_SENHA}    ${SENHA_PADRAO}
    Click Button      ${BOTAO_ENTRAR}
    Wait Until Location Contains    /home    timeout=${TIMEOUT}
    Wait Until Element Is Visible   ${MENU_SAIR}    timeout=${TIMEOUT}

# ---------- Lista de Compras ----------
Acessar a pagina de listas de compras
    # Navega: telas como "Adicionar Item" nao exibem o menu lateral
    Go To    url=${URL}/compras
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_LISTA}    timeout=${TIMEOUT}

Arquivar a lista de compras
    Acessar a pagina de listas de compras
    Wait Until Element Is Visible    ${CARD_LISTA}    timeout=${TIMEOUT}
    Click Button    ${BOTAO_ARQUIVAR_LISTA}
    Wait Until Element Is Visible    ${BOTAO_CONFIRMAR}    timeout=${TIMEOUT}
    Click Button    ${BOTAO_CONFIRMAR}

Verificar que a lista foi arquivada
    Wait Until Element Contains    ${BADGE_STATUS_LISTA}    Arquivada    timeout=${TIMEOUT}
    ...    error=A lista nao exibiu o status "Arquivada" apos a acao.
    Page Should Not Contain Element    ${BOTAO_ARQUIVAR_LISTA}
    ...    message=Os botoes de acao continuam disponiveis em uma lista arquivada.
