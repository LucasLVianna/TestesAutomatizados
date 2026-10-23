*** Settings ***
Resource          ct20_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT20 - Tentar enviar mensagem em branco no chat de suporte
    [Documentation]    Passo-a-passo: 1- Abrir o chat de suporte (Tickets > "Chat" do ticket); 2- Deixar a caixa de texto
    ...                sem nenhum caractere; 3- Clicar no botao "Enviar" ou pressionar ENTER (as duas formas sao testadas).
    ...                Resultado esperado: 1- Chat de suporte aberto; 2- Caixa em branco; 3- A acao e bloqueada, impedindo
    ...                o envio de mensagens sem conteudo, e uma mensagem de alerta e exibida.
    [Tags]             suporte    chat    baixa
    Efetuar login no MyKeeper
    Abrir o chat de suporte
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
