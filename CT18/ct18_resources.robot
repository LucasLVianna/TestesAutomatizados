*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
# ---------- Ambiente ----------
${BROWSER}                     Chrome
${URL}                         http://localhost/mykeeper
${HEADLESS}                    False
${TIMEOUT}                     10s

# ---------- Massa de dados ----------
${NOME_USUARIO}                Usuario Teste CT18
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${NOME_LISTA}                  Lista CT18

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

# ---------- Lista de Compras / Compartilhamento ----------
${BOTAO_ADICIONAR_LISTA}       id:criarCompras
${CAMPO_TITULO_LISTA}          id:titulo
${BOTAO_SALVAR_LISTA}          id:addcompras
${BOTAO_COMPARTILHAR_LISTA}    xpath://div[contains(@class,'card')][.//p[contains(@class,'card-nome')][normalize-space()='${NOME_LISTA}']]//button[normalize-space()='Compartilhar']
${MSG_LINK_COPIADO}            Link da lista copiado com sucesso.
${MSG_LINK_INVALIDO}           Lista não encontrada.

*** Keywords ***
# ---------- Navegador ----------
Abrir o navegador
    [Arguments]    ${alias}=principal    ${anonimo}=${False}
    ${opcoes}=    Montar opcoes do navegador    ${anonimo}
    Open Browser    ${URL}    ${BROWSER}    alias=${alias}    options=${opcoes}
    Maximize Browser Window

Montar opcoes do navegador
    [Arguments]    ${anonimo}=${False}
    ${opcoes}=    Set Variable    add_argument("--window-size=1920,1080")
    IF    $HEADLESS.lower() == 'true'
        ${opcoes}=    Set Variable    ${opcoes};add_argument("--headless=new")
    END
    IF    ${anonimo}
        ${opcoes}=    Set Variable    ${opcoes};add_argument("--incognito")
    END
    RETURN    ${opcoes}

Fechar o navegador
    Capture Page Screenshot
    # O caso abre um segundo navegador (anonimo), fecha os dois
    Close All Browsers

# ---------- Massa de dados ----------
Preparar massa de dados do caso
    ${id_execucao}=    Evaluate    str(time.time_ns())    modules=time
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct18@teste.com
    Abrir o navegador    alias=preparacao
    Cadastrar usuario de teste
    Efetuar login no MyKeeper
    Cadastrar lista de compras
    Close All Browsers

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

# ---------- Lista de Compras / Compartilhamento ----------
Acessar a pagina de listas de compras
    Go To    url=${URL}/compras
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_LISTA}    timeout=${TIMEOUT}

Gerar link de compartilhamento da lista
    Acessar a pagina de listas de compras
    # O sistema copia o link para a area de transferencia; intercepta a API do navegador
    Execute Javascript    window.__linkCopiado = null; navigator.clipboard.writeText = (t) => { window.__linkCopiado = t; return Promise.resolve(); };
    Click Button    ${BOTAO_COMPARTILHAR_LISTA}
    Wait Until Page Contains    ${MSG_LINK_COPIADO}    timeout=${TIMEOUT}
    Wait For Condition    return window.__linkCopiado !== null    timeout=${TIMEOUT}
    ${link}=    Execute Javascript    return window.__linkCopiado
    Log    Link gerado pelo sistema: ${link}
    # Reaproveita so a rota(o dominio pode ser ngrok) e monta a URL com ${URL}
    ${rota}=    Evaluate    (lambda u: u.path.rsplit('/', 1)[-1] + '?' + u.query)(urllib.parse.urlsplit($link))    modules=urllib.parse
    Should Contain    ${rota}    token=
    RETURN    ${URL}/${rota}

Alterar um caractere do token na URL
    [Arguments]    ${url_link}
    ${ultimo}=    Get Substring    ${url_link}    -1
    ${novo}=      Set Variable If    '${ultimo}' == 'a'    b    a
    ${prefixo}=   Get Substring    ${url_link}    0    -1
    ${url_alterada}=    Set Variable    ${prefixo}${novo}
    Should Not Be Equal    ${url_alterada}    ${url_link}
    Log    URL com token alterado: ${url_alterada}
    RETURN    ${url_alterada}

Acessar o link em sessao sem login
    [Arguments]    ${url_link}
    Abrir o navegador    alias=anonimo    anonimo=${True}
    Go To    url=${url_link}
    Wait Until Page Contains Element    tag:body    timeout=${TIMEOUT}

Verificar que o link foi recusado sem expor a lista
    Wait Until Page Contains    ${MSG_LINK_INVALIDO}    timeout=${TIMEOUT}
    Page Should Not Contain    ${NOME_LISTA}
    Page Should Not Contain Element    tag:table
