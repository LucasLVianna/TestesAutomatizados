*** Settings ***
Resource          ct18_resources.robot
Suite Setup       Preparar massa de dados do caso
Test Setup        Abrir o navegador
Test Teardown     Fechar o navegador

*** Test Cases ***
CT18 - Acessar link de lista de compras compartilhado com link incorreto
    [Documentation]    Passo-a-passo: 1- Gerar link de compartilhamento de lista (botao "Compartilhar"; link ngrok);
    ...                2- Modificar um caractere do token na URL (simulando link expirado); 3- Acessar a URL alterada em aba anonima.
    ...                Resultado esperado: 1- Link gerado com sucesso; 2- Token adulterado; 3- O sistema intercepta o acesso
    ...                e exibe pagina informando que o link e invalido, sem expor os dados da lista.
    ...                Mensagem aceita como "link invalido" (decisao aprovada): "Lista não encontrada.".
    [Tags]             lista_compras    seguranca    alta
    Efetuar login no MyKeeper
    ${link}=             Gerar link de compartilhamento da lista
    ${link_alterado}=    Alterar um caractere do token na URL    ${link}
    Acessar a URL alterada em aba anonima    ${link_alterado}
    Verificar que o link foi recusado sem expor a lista
