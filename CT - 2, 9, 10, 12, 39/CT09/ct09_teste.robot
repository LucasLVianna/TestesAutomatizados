*** Settings ***
Documentation     CT09 - Impedir inserção de item com quantidade negativa no estoque.
...               Passo a passo:
...               1- Com um perfil logado, um produto e um estoque pré-cadastrados, abrir página de "Itens do Estoque";
...               2- Clicar em "Novo Item";
...               3- Escolher um produto pré-cadastrado;
...               4- Informar Quantidade = -1;
...               5- Clicar em "+ Adicionar".
Resource          ct09_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT09 - Inserir item no estoque com quantidade negativa
    [Documentation]    Verifica se o sistema impede a inserção de item com quantidade negativa (-1) no estoque,
    ...                validando a aceitação do valor digitado e a exibição do alerta "A quantidade deve ser maior do que 0".
    [Tags]    estoque    validacao    quantidade_invalida    caixa_preta    ct09
    Acessar pagina de itens do estoque
    Clicar em novo item
    Escolher um produto pre-cadastrado    ${PRODUTO_ALVO}
    Informar quantidade do item           ${QUANTIDADE_INVALIDA}
    Clicar em adicionar item
    O sistema impede o salvamento exibindo alerta "A quantidade deve ser maior do que 0"
