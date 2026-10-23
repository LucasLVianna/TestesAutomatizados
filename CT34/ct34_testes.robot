*** Settings ***
Resource          ct34_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT34 - Validar o acesso negado no login com senha incorreta
    [Documentation]    Ao tentar entrar com um e-mail cadastrado e uma senha incorreta, o sistema
    ...                deve impedir o login, permanecer na tela de login e exibir a mensagem
    ...                "Email ou senha incorretos", sem exibir o menu de usuario logado.
    [Tags]             autenticacao    login    funcionalidade    alta
    Tentar efetuar login    ${SENHA_INCORRETA}
    Verificar que o login foi recusado
