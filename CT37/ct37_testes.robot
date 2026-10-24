*** Settings ***
Resource          ct37_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT37 - Excluir um item do estoque e confirmar sua remocao da listagem
    [Documentation]    Ao excluir um item do estoque e confirmar a acao, o sistema deve exibir a
    ...                mensagem "Item excluido com sucesso" e o item deve deixar de aparecer na
    ...                listagem do estoque.
    [Tags]             estoque    itens    funcionalidade    media
    Efetuar login no MyKeeper
    Abrir a tela de itens do estoque
    Excluir o item do estoque
    Verificar que o item foi excluido
