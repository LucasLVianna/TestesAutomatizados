*** Settings ***
Documentation     CT12 - Impedir o cadastro de uma categoria já cadastrada.
...               Passo a passo:
...               1- Acessar "Categorias";
...               2- Clicar em "Adicionar Categoria";
...               3- No campo nome, digitar uma categoria já existente;
...               4- Preencher a descrição com "...";
...               5- Clicar em "Adicionar".
Resource          ct12_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT12 - Impedir cadastro de categoria duplicada
    [Documentation]    Verifica se o sistema impede cadastrar novamente uma categoria existente e exibe "ERRO! Categoria já cadastrada.".
    [Tags]    categorias    validacao    duplicidade    caixa_preta    ct12
    Acessar pagina de categorias
    Selecionar uma categoria ja cadastrada
    Clicar em adicionar categoria
    Preencher os dados da categoria existente
    Clicar em adicionar
    O sistema impede o cadastro da categoria duplicada
