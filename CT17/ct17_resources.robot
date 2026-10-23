*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ---------- Ambiente ----------
${BROWSER}                     Chrome
${URL}                         http://localhost/mykeeper
${HEADLESS}                    False
${TIMEOUT}                     10s

# ---------- Massa de dados ----------
${NOME_USUARIO}                Usuario Teste CT17
${CEP_USUARIO}                 80215-901
${SENHA_PADRAO}                Senha@123
${NOME_CATEGORIA}              Mercearia CT17
${DESCRICAO_CATEGORIA}         Alimentos secos
${NOME_PRODUTO}                Arroz CT17
${UNIDADE_PRODUTO}             Quilo (Kg)
${NOME_LISTA}                  Lista CT17

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

# ---------- Lista de Compras ----------
${BOTAO_ADICIONAR_LISTA}       id:criarCompras
${CAMPO_TITULO_LISTA}          id:titulo
${BOTAO_SALVAR_LISTA}          id:addcompras
${CARD_LISTA}                  xpath://p[contains(@class,'card-nome')][normalize-space()='${NOME_LISTA}']
${BOTAO_NOVO_ITEM}             id:adicionarItem
${CARD_PRODUTO}                xpath://div[contains(@class,'card')][div[contains(@class,'card-nome')][normalize-space()='${NOME_PRODUTO}']]
${CAMPO_QUANTIDADE_PRODUTO}    ${CARD_PRODUTO}//input[@placeholder='Quantidade']
${BOTAO_ADICIONAR_PRODUTO}     ${CARD_PRODUTO}//button[normalize-space()='+ Adicionar']
${ALERTA_QUANTIDADE_OBRIGATORIA}    xpath://*[not(self::script)][contains(translate(normalize-space(text()),'QUANTIDADEOBRIGATÓ','quantidadeobrigató'),'quantidade') and contains(translate(normalize-space(text()),'QUANTIDADEOBRIGATÓ','quantidadeobrigató'),'obrigat')]
${MSG_LISTA_SEM_ITENS}         Não há itens cadastrados nesta lista de compra.

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

# ---------- Massa de dados  ----------
Preparar massa de dados do caso
    ${id_execucao}=    Evaluate    str(time.time_ns())    modules=time
    Set Suite Variable    ${EMAIL_USUARIO}    teste_${id_execucao}_ct17@teste.com
    Abrir o navegador
    Cadastrar usuario de teste
    Efetuar login no MyKeeper
    Cadastrar categoria
    Cadastrar produto
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

Abrir a lista de compras
    Acessar a pagina de listas de compras
    Click Element    ${CARD_LISTA}
    Wait Until Element Is Visible    ${BOTAO_NOVO_ITEM}    timeout=${TIMEOUT}

Clicar em adicionar item
    Click Button    ${BOTAO_NOVO_ITEM}
    Wait Until Element Is Visible    ${CARD_PRODUTO}    timeout=${TIMEOUT}

Selecionar o produto deixando a quantidade em branco
    Clear Element Text    ${CAMPO_QUANTIDADE_PRODUTO}
    Textfield Value Should Be    ${CAMPO_QUANTIDADE_PRODUTO}    ${EMPTY}

Confirmar a adicao do item
    Click Button    ${BOTAO_ADICIONAR_PRODUTO}

Verificar alerta de quantidade obrigatoria
    Wait Until Element Is Visible    ${ALERTA_QUANTIDADE_OBRIGATORIA}    timeout=${TIMEOUT}
    ...    error=O sistema nao exibiu alerta informando que o campo "Quantidade" e obrigatorio.

Verificar que o item nao foi adicionado a lista
    Abrir a lista de compras
    Wait Until Page Contains    ${MSG_LISTA_SEM_ITENS}    timeout=${TIMEOUT}
    ...    error=O item foi adicionado a lista mesmo sem informar a quantidade.
    Page Should Not Contain    ${NOME_PRODUTO}
