*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ---------- Ambiente ----------
${BROWSER}                     Chrome
${URL}                         http://localhost/mykeeper
${HEADLESS}                    False
${TIMEOUT}                     10s

# ---------- Massa de dados ----------
${NOME_USUARIO}                Usuario Teste CT20
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${TITULO_TICKET}               Ticket CT20
${DESCRICAO_TICKET}            Ticket criado pela automacao para testar o chat

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

# ---------- Tickets / Chat ----------
${MENU_TICKETS}                id:ticketButtonLink
${BOTAO_ADICIONAR_TICKET}      id:ticket_novo
${CAMPO_TITULO_TICKET}         id:titulo
${CAMPO_DESCRICAO_TICKET}      id:descricao
${BOTAO_CRIAR_TICKET}          id:criarTicket
${LINK_CHAT_TICKET}            xpath://tr[td[normalize-space()='${TITULO_TICKET}']]//a[normalize-space()='Chat']
${CAMPO_MENSAGEM_CHAT}         id:input-mensagem
${BOTAO_ENVIAR_CHAT}           id:btn-enviar
${ALERTA_CHAT}                 id:error-chat
${MENSAGENS_CHAT}              css:#chat-messages .msg
${MSG_CHAT_VAZIO}              Digite uma mensagem antes de enviar.

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
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct20@teste.com
    Abrir o navegador
    Cadastrar usuario de teste
    Efetuar login no MyKeeper
    Cadastrar ticket de suporte
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

Cadastrar ticket de suporte
    Acessar a pagina de tickets
    Click Button    ${BOTAO_ADICIONAR_TICKET}
    Wait Until Element Is Visible    ${CAMPO_TITULO_TICKET}    timeout=${TIMEOUT}
    Input Text      ${CAMPO_TITULO_TICKET}       ${TITULO_TICKET}
    Input Text      ${CAMPO_DESCRICAO_TICKET}    ${DESCRICAO_TICKET}
    Click Button    ${BOTAO_CRIAR_TICKET}
    Wait Until Location Does Not Contain    ticket_usuario_novo    timeout=${TIMEOUT}
    Wait Until Page Contains Element    ${LINK_CHAT_TICKET}    timeout=${TIMEOUT}

# ---------- Login ----------
Efetuar login no MyKeeper
    Go To    url=${URL}/usuario_login
    Wait Until Element Is Visible    ${CAMPO_EMAIL}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_USUARIO}
    Input Password    ${CAMPO_SENHA}    ${SENHA_PADRAO}
    Click Button      ${BOTAO_ENTRAR}
    Wait Until Location Contains    /home    timeout=${TIMEOUT}
    Wait Until Element Is Visible   ${MENU_SAIR}    timeout=${TIMEOUT}

# ---------- Tickets / Chat ----------
Acessar a pagina de tickets
    Click Button    ${MENU_TICKETS}
    Wait Until Element Is Visible    ${BOTAO_ADICIONAR_TICKET}    timeout=${TIMEOUT}

Abrir o chat do ticket
    Acessar a pagina de tickets
    Click Element    ${LINK_CHAT_TICKET}
    Wait Until Element Is Visible    ${CAMPO_MENSAGEM_CHAT}    timeout=${TIMEOUT}

Contar mensagens do chat
    ${qtd}=    Get Element Count    ${MENSAGENS_CHAT}
    RETURN    ${qtd}

Clicar em enviar com a mensagem vazia
    Clear Element Text    ${CAMPO_MENSAGEM_CHAT}
    Click Button    ${BOTAO_ENVIAR_CHAT}

Pressionar ENTER com a mensagem vazia
    Clear Element Text    ${CAMPO_MENSAGEM_CHAT}
    Press Keys    ${CAMPO_MENSAGEM_CHAT}    RETURN

Recarregar o chat
    Reload Page
    Wait Until Element Is Visible    ${CAMPO_MENSAGEM_CHAT}    timeout=${TIMEOUT}
    Element Text Should Be    ${ALERTA_CHAT}    ${EMPTY}

Verificar que o envio vazio foi bloqueado
    [Arguments]    ${qtd_antes}
    Wait Until Element Contains    ${ALERTA_CHAT}    ${MSG_CHAT_VAZIO}    timeout=${TIMEOUT}
    ${qtd_depois}=    Contar mensagens do chat
    Should Be Equal As Integers    ${qtd_depois}    ${qtd_antes}
    ...    msg=Uma mensagem vazia foi adicionada ao historico do chat.
