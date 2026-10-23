*** Settings ***
Resource          ct33_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT33 - Alterar senha informando a senha atual incorreta
    [Documentation]    Passo-a-passo: 1- Acessar a aba "Perfil"; 2- Clicar em "Mudar Senha";
    ...                3- Preencher "Senha" com a senha atual incorreta e "Nova Senha" com uma senha valida;
    ...                4- Clicar em "Salvar"; 5- Fazer logout e tentar logar com a nova senha; 6- Logar com a senha original.
    ...                Resultado esperado: 1- Tela do perfil aberta; 2- Formulario de alteracao de senha aparece;
    ...                3- Campos preenchidos; 4- O sistema recusa a alteracao e exibe a mensagem "Senha atual incorreta";
    ...                5- O login com a nova senha e recusado; 6- O login com a senha original e efetuado com sucesso.
    ...                Versao funcional (caixa-preta) do CT23.
    [Tags]             perfil    senha    seguranca    alta
    Efetuar login no MyKeeper     ${SENHA_PADRAO}
    Acessar a aba perfil
    Clicar em mudar senha
    Preencher a alteracao de senha    ${SENHA_INCORRETA}    ${NOVA_SENHA}
    Clicar em salvar
    Verificar mensagem de senha atual incorreta
    Efetuar logout
    Tentar efetuar login          ${NOVA_SENHA}
    Verificar que o login foi recusado
    Efetuar login no MyKeeper     ${SENHA_PADRAO}
