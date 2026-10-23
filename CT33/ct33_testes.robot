*** Settings ***
Resource          ct33_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT33 - Alterar senha informando a senha atual incorreta
    [Documentation]    Ao tentar alterar a senha informando uma senha atual incorreta, o sistema
    ...                deve recusar a alteracao e exibir mensagem de erro; a senha nao pode ser
    ...                alterada (login com a nova senha falha e com a original funciona).
    ...                Versao funcional (caixa-preta) do CT23.
    [Tags]             perfil    senha    seguranca    alta
    Efetuar login no MyKeeper     ${SENHA_PADRAO}
    Acessar a tela de mudar senha
    Preencher a alteracao de senha    ${SENHA_INCORRETA}    ${NOVA_SENHA}
    Verificar mensagem de senha atual incorreta
    Efetuar logout
    Tentar efetuar login          ${NOVA_SENHA}
    Verificar que o login foi recusado
    Efetuar login no MyKeeper     ${SENHA_PADRAO}
