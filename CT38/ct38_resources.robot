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
${NOME_USUARIO}                Usuario Teste CT38
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${NOME_CATEGORIA}              Laticinios CT38
${DESCRICAO_CATEGORIA}         Itens da geladeira
${NOME_PRODUTO}                Queijo CT38
${UNIDADE_PRODUTO}             Quilo (Kg)
${NOME_ESTOQUE}                Geladeira CT38
${QUANTIDADE_INICIAL}          2
${NOVA_QUANTIDADE}             5
${NOVA_VALIDADE}               2030-12-31

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

# ---------- Categoria / Produto ----------
${CAMPO_NOME_CATEGORIA}        id:nome_categoria
${CAMPO_DESCRICAO_CATEGORIA}   id:descricao_categoria
${BOTAO_ADD_CATEGORIA}         id:addcategoria
${CAMPO_NOME_PRODUTO}          id:nome_produto
${SELECT_CATEGORIA_PRODUTO}    id:categoria_produto
${SELECT_UNIDADE_PRODUTO}      id:und_medida_produto
${BOTAO_ADD_PRODUTO}           id:addproduto

# ---------- Estoque / Itens ----------
${CAMPO_NOME_ESTOQUE}          id:nome_estoque
${BOTAO_ADD_ESTOQUE}           id:addestoque
${CARD_ESTOQUE}                xpath://div[contains(@class,'card')][.//div[contains(@class,'card-nome')][normalize-space()='${NOME_ESTOQUE}']]
${BOTAO_NOVO_ITEM}             id:adicionarItem
${CARD_PRODUTO_ADICIONAR}      xpath://div[contains(@class,'card')][.//div[contains(@class,'card-nome')][normalize-space()='${NOME_PRODUTO}']]
${CAMPO_QUANTIDADE_ADICIONAR}  ${CARD_PRODUTO_ADICIONAR}//input[starts-with(@id,'quantidade-')]
${BOTAO_ADICIONAR_ITEM}        ${CARD_PRODUTO_ADICIONAR}//button[normalize-space()='+ Adicionar']
${MSG_ITEM_ADICIONADO}         Item adicionado com sucesso
${CARD_ITEM}                   xpath://div[contains(@class,'card')][.//div[contains(@class,'card-nome')][normalize-space()='${NOME_PRODUTO}']]
${LINK_EDITAR_ITEM}            ${CARD_ITEM}//a[normalize-space()='Editar']

# ---------- Alterar item ----------
${CAMPO_QUANTIDADE_ITEM}       id:quantidade
${CAMPO_VALIDADE_ITEM}         id:data_validade
${BOTAO_SALVAR_ITEM}           id:alteraritem
${MENSAGEM_ALTERACAO}          id:error
${MSG_ITEM_ALTERADO}           SUCESSO! Item alterado com sucesso

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
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct38@teste.com
    Abrir o navegador
    Cadastrar usuario de teste
    Efetuar login no MyKeeper
    Cadastrar categoria
    Cadastrar produto
    Cadastrar estoque
    Adicionar produto ao estoque
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

Cadastrar categoria
    Go To    url=${URL}/categoria_novo
    Wait Until Element Is Visible    ${CAMPO_NOME_CATEGORIA}    timeout=${TIMEOUT}
    Input Text      ${CAMPO_NOME_CATEGORIA}         ${NOME_CATEGORIA}
    Input Text      ${CAMPO_DESCRICAO_CATEGORIA}    ${DESCRICAO_CATEGORIA}
    Click Button    ${BOTAO_ADD_CATEGORIA}
    Wait Until Location Does Not Contain    categoria_novo    timeout=${TIMEOUT}
    Wait Until Page Contains    ${NOME_CATEGORIA}    timeout=${TIMEOUT}

Cadastrar produto
    Go To    url=${URL}/produto_novo
    Wait Until Element Is Visible    ${CAMPO_NOME_PRODUTO}    timeout=${TIMEOUT}
    Input Text    ${CAMPO_NOME_PRODUTO}    ${NOME_PRODUTO}
    Wait Until Keyword Succeeds    ${TIMEOUT}    500ms
    ...    Select From List By Label    ${SELECT_CATEGORIA_PRODUTO}    ${NOME_CATEGORIA}
    Select From List By Label    ${SELECT_UNIDADE_PRODUTO}    ${UNIDADE_PRODUTO}
    Click Button    ${BOTAO_ADD_PRODUTO}
    Wait Until Location Does Not Contain    produto_novo    timeout=${TIMEOUT}
    Wait Until Page Contains    ${NOME_PRODUTO}    timeout=${TIMEOUT}

Cadastrar estoque
    Go To    url=${URL}/estoque_adicionar
    Wait Until Element Is Visible    ${CAMPO_NOME_ESTOQUE}    timeout=${TIMEOUT}
    Input Text      ${CAMPO_NOME_ESTOQUE}    ${NOME_ESTOQUE}
    Click Button    ${BOTAO_ADD_ESTOQUE}
    Wait Until Location Does Not Contain    estoque_adicionar    timeout=${TIMEOUT}
    Wait Until Page Contains    ${NOME_ESTOQUE}    timeout=${TIMEOUT}

Adicionar produto ao estoque
    Abrir a tela de itens do estoque
    Click Button    ${BOTAO_NOVO_ITEM}
    Wait Until Element Is Visible    ${CARD_PRODUTO_ADICIONAR}    timeout=${TIMEOUT}
    Input Text    ${CAMPO_QUANTIDADE_ADICIONAR}    ${QUANTIDADE_INICIAL}
    Click Button    ${BOTAO_ADICIONAR_ITEM}
    Wait Until Page Contains    ${MSG_ITEM_ADICIONADO}    timeout=${TIMEOUT}

# ---------- Login ----------
Efetuar login no MyKeeper
    Go To    url=${URL}/usuario_login
    Wait Until Element Is Visible    ${CAMPO_EMAIL}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_EMAIL}    ${EMAIL_USUARIO}
    Input Password    ${CAMPO_SENHA}    ${SENHA_PADRAO}
    Click Button      ${BOTAO_ENTRAR}
    Wait Until Location Contains    /home    timeout=${TIMEOUT}
    Wait Until Element Is Visible   ${MENU_SAIR}    timeout=${TIMEOUT}

# ---------- Estoque ----------
Abrir a tela de itens do estoque
    Go To    url=${URL}/estoque
    Wait Until Element Is Visible    ${CARD_ESTOQUE}    timeout=${TIMEOUT}
    Click Element    ${CARD_ESTOQUE}
    Wait Until Element Is Visible    ${BOTAO_NOVO_ITEM}    timeout=${TIMEOUT}

Abrir a tela de edicao do item
    Abrir a tela de itens do estoque
    Wait Until Element Is Visible    ${CARD_ITEM}    timeout=${TIMEOUT}
    Click Element    ${LINK_EDITAR_ITEM}
    Wait Until Element Is Visible    ${CAMPO_QUANTIDADE_ITEM}    timeout=${TIMEOUT}

Alterar quantidade e validade do item
    Clear Element Text    ${CAMPO_QUANTIDADE_ITEM}
    Input Text            ${CAMPO_QUANTIDADE_ITEM}    ${NOVA_QUANTIDADE}
    # campo do tipo data: preenchido via JavaScript para nao depender do formato do navegador
    Execute Javascript    document.getElementById('data_validade').value = '${NOVA_VALIDADE}';
    Click Button          ${BOTAO_SALVAR_ITEM}

Verificar que o item foi alterado
    Wait Until Element Contains    ${MENSAGEM_ALTERACAO}    ${MSG_ITEM_ALTERADO}    timeout=${TIMEOUT}
    ...    error=O sistema nao exibiu a mensagem de alteracao do item.
    Wait Until Location Contains    estoque_itens    timeout=${TIMEOUT}
    Wait Until Page Contains    Quantidade: ${NOVA_QUANTIDADE}    timeout=${TIMEOUT}
    ...    error=A listagem nao exibiu a nova quantidade do item.
