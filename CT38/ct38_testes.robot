*** Settings ***
Resource          ct38_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT38 - Editar quantidade e data de validade de um item do estoque
    [Documentation]    Ao alterar a quantidade e a data de validade de um item do estoque e salvar,
    ...                o sistema deve exibir a mensagem "Item alterado com sucesso" e retornar a
    ...                listagem exibindo a nova quantidade.
    [Tags]             estoque    itens    funcionalidade    media
    Efetuar login no MyKeeper
    Abrir a tela de edicao do item
    Alterar quantidade e validade do item
    Verificar que o item foi alterado
