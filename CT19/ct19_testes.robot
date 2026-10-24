*** Settings ***
Resource          ct19_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT19 - Alterar a senha de acesso com sucesso no perfil
    [Documentation]    Passo-a-passo: 1- Acessar a aba "Perfil"; 2- Clicar em "Mudar Senha";
    ...                3- Preencher "Senha" (senha atual) e "Nova Senha"; 4- Clicar em "Salvar";
    ...                5- Fazer logout e logar com a nova senha.
    ...                Resultado esperado: 1- Tela do perfil aberta; 2- Formulario de alteracao de senha aparece;
    ...                3- Campos preenchidos; 4- Mensagem de sucesso exibida; 5- O novo login e efetuado com sucesso
    ...                usando exclusivamente a nova credencial (o login com a senha antiga e recusado).
    [Tags]             perfil    senha    alta
    Efetuar login no MyKeeper     ${SENHA_PADRAO}
    Acessar a aba perfil
    Clicar em mudar senha
    Preencher a alteracao de senha    ${SENHA_PADRAO}    ${NOVA_SENHA}
    Clicar em salvar
    Verificar mensagem de senha alterada com sucesso
    Efetuar logout
    Efetuar login no MyKeeper     ${NOVA_SENHA}
    Efetuar logout
    Tentar efetuar login          ${SENHA_PADRAO}
    Verificar que o login foi recusado
