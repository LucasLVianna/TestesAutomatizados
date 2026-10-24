*** Settings ***
Documentation     CT39 - Alterar o nome de uma categoria já cadastrada.
...               Passo a passo:
...               1- Com um perfil logado e a categoria "Laticínios" cadastrada, acessar "Categorias";
...               2- Clicar em "Editar" na categoria "Laticínios";
...               3- Alterar o campo "Nome" para "Frios";
...               4- Clicar em "Alterar".
Resource          ct39_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT39 - Alterar nome da categoria Laticinios para Frios
    [Documentation]    Verifica a confirmação de sucesso e se a listagem exibe "Frios" no lugar de "Laticínios".
    [Tags]    categorias    alteracao    nome    caixa_preta    ct39
    Acessar pagina de categorias
    Clicar em editar na categoria Laticinios
    Alterar o nome da categoria para Frios
    Clicar em alterar
    O sistema confirma a alteracao e atualiza a categoria na lista