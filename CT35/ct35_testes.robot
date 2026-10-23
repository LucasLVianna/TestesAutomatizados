*** Settings ***
Resource          ct35_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT35 - Enviar mensagem valida no chat de um ticket de suporte
    [Documentation]    Ao digitar uma mensagem valida no chat de um ticket aberto e clicar em "Enviar",
    ...                a mensagem deve aparecer no historico do chat e continuar disponivel apos
    ...                recarregar a pagina.
    [Tags]             suporte    chat    funcionalidade    media
    Efetuar login no MyKeeper
    Abrir o chat do ticket
    Enviar mensagem no chat    ${MENSAGEM_CHAT}
    Verificar que a mensagem foi enviada e registrada    ${MENSAGEM_CHAT}
