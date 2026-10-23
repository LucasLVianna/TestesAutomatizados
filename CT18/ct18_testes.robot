*** Settings ***
Resource          ct18_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT18 - Acessar link de lista de compras compartilhado com link incorreto
    [Documentation]    Ao acessar, sem login, o link de compartilhamento de uma lista com um
    ...                caractere do token alterado, o sistema deve informar que o link e
    ...                invalido sem expor os dados da lista.
    [Tags]             lista_compras    seguranca    alta
    Efetuar login no MyKeeper
    ${link}=             Gerar link de compartilhamento da lista
    ${link_alterado}=    Alterar um caractere do token na URL    ${link}
    Acessar o link em sessao sem login    ${link_alterado}
    Verificar que o link foi recusado sem expor a lista
