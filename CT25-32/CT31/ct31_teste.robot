*** Settings ***
Documentation     CT31 - Logoff.
Resource          ct31_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT31 - Logoff impede acesso a página protegida
    [Documentation]    Após o logoff, acessar uma página protegida pela URL
    ...                deve redirecionar para a página de login, sem sessão ativa.
    [Tags]    seguranca    sessao    caixa_preta
    ${url_protegida}=    Guardar URL da pagina protegida
    Fazer logoff
    Acesso a pagina protegida deve ser bloqueado    ${url_protegida}