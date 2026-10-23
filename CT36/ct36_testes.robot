*** Settings ***
Resource          ct36_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT36 - Arquivar uma lista de compras aberta
    [Documentation]    Ao arquivar uma lista com status "Aberta" e confirmar a acao, a lista deve
    ...                passar a exibir o status "Arquivada" e deixar de oferecer os botoes de acao.
    [Tags]             lista_compras    status    funcionalidade    media
    Efetuar login no MyKeeper
    Arquivar a lista de compras
    Verificar que a lista foi arquivada
