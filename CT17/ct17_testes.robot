*** Settings ***
Resource          ct17_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT17 - Adicionar item na lista de compras omitindo a quantidade do produto
    [Documentation]    Ao tentar adicionar um produto a lista de compras sem informar a quantidade,
    ...                o sistema deve bloquear a adicao, alertar que o campo "Quantidade" e
    ...                obrigatorio e o item nao deve aparecer na lista.
    ...                Defeito conhecido: hoje o sistema adiciona o item com sucesso (teste deve falhar).
    [Tags]             lista_compras    alta    bug_conhecido
    Efetuar login no MyKeeper
    Abrir a lista de compras
    Clicar em adicionar item
    Selecionar o produto deixando a quantidade em branco
    Confirmar a adicao do item
    Run Keyword And Continue On Failure    Verificar alerta de quantidade obrigatoria
    Verificar que o item nao foi adicionado a lista
