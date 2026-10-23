*** Settings ***
Resource          ct20_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT20 - Tentar enviar mensagem em branco no chat de suporte
    [Documentation]    Ao tentar enviar uma mensagem vazia no chat do ticket, pelo botao "Enviar"
    ...                e pela tecla ENTER, o sistema deve bloquear o envio, exibir um alerta
    ...                e nenhuma mensagem vazia deve aparecer no historico.
    [Tags]             suporte    chat    baixa
    Efetuar login no MyKeeper
    Abrir o chat do ticket
    ${qtd_antes}=    Contar mensagens do chat
    Clicar em enviar com a mensagem vazia
    Verificar que o envio vazio foi bloqueado    ${qtd_antes}
    Recarregar o chat
    Pressionar ENTER com a mensagem vazia
    Verificar que o envio vazio foi bloqueado    ${qtd_antes}
    Recarregar o chat
    ${qtd_final}=    Contar mensagens do chat
    Should Be Equal As Integers    ${qtd_final}    ${qtd_antes}
    ...    msg=O historico do chat registrou mensagem vazia.
