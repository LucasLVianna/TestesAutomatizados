*** Settings ***
Resource          ct19_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT19 - Alterar a senha de acesso com sucesso no perfil
    [Documentation]    Ao alterar a senha no perfil informando a senha atual correta, o sistema
    ...                deve exibir mensagem de sucesso; o login com a nova senha deve funcionar
    ...                e o login com a senha antiga deve deixar de funcionar.
    [Tags]             perfil    senha    alta
    Efetuar login no MyKeeper     ${SENHA_PADRAO}
    Acessar a tela de mudar senha
    Preencher a alteracao de senha    ${SENHA_PADRAO}    ${NOVA_SENHA}
    Verificar mensagem de senha alterada com sucesso
    Efetuar logout
    Efetuar login no MyKeeper     ${NOVA_SENHA}
    Efetuar logout
    Tentar efetuar login          ${SENHA_PADRAO}
    Verificar que o login foi recusado
