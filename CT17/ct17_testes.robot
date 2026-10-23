*** Settings ***
Resource          ct17_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT17 - Adicionar item na lista de compras omitindo a quantidade do produto
    [Documentation]    Passo-a-passo: 1- Acessar "Compras" e abrir a lista de compras; 2- Clicar em "Novo Item";
    ...                3- Deixar o campo "Quantidade" do produto em branco; 4- Clicar em "+ Adicionar" no card do produto.
    ...                Resultado esperado: 1- Tela da lista exibida; 2- Tela "Adicionar Item" aberta; 3- Quantidade omitida;
    ...                4- O sistema bloqueia a adicao e alerta que o campo "Quantidade" e obrigatorio (o item nao aparece na lista).
    ...                Defeito conhecido: hoje o sistema adiciona o item com sucesso (teste deve falhar).
    [Tags]             lista_compras    alta    bug_conhecido
    Efetuar login no MyKeeper
    Abrir a lista de compras
    Clicar em novo item
    Deixar a quantidade do produto em branco
    Clicar em adicionar no card do produto
    Run Keyword And Continue On Failure    Verificar alerta de quantidade obrigatoria
    Verificar que o item nao foi adicionado a lista
