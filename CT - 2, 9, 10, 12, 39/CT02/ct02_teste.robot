*** Settings ***
Documentation     CT02 - Impedir cadastro com e-mail inválido.
...               Passo a passo:
...               1- Acessar a tela inicial do MyKeeper;
...               2- Clicar em "Cadastrar-se";
...               3- Preencher nome "Usuário Válido", CEP 81280080 e senha "Teste12345678*";
...               4- Preencher o e-mail inválido "usuario.invalido.com", sem @;
...               5- Clicar em "Cadastrar".
Resource          ct02_resources.robot
Test Setup        Abrir o navegador e acessar cadastro
Test Teardown     Fechar o navegador


*** Test Cases ***
CT02 - Impedir cadastro com e-mail inválido
    [Documentation]    Verifica que o sistema impede o cadastro com "usuario.invalido.com" e exibe "ERRO! Digite um e-mail válido.".
    [Tags]    cadastro    validacao    email_invalido    caixa_preta    ct02
    Preencher formulario com email invalido
    Clicar em cadastrar
    Validar mensagem solicitando email valido