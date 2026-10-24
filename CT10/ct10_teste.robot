*** Settings ***
Documentation     CT10 - Verifica se os cards do menu principal cabem na tela mobile sem sobreposição.
...               Passo a passo:
...               1- Acessar o menu principal do MyKeeper com usuário logado;
...               2- Ativar a simulação mobile em 375x667px;
...               3- Rolar a página e conferir os cards Meus Produtos, Estoque, Lista de Compras, Receitas, Categorias e Suporte, inclusive se não ficam atrás da barra fixa.
Resource          ct10_resources.robot
Test Setup        Abrir o navegador e fazer login
Test Teardown     Fechar o navegador


*** Test Cases ***
CT10 - Exibir todos os cards do menu principal em mobile
    [Documentation]    Verifica a abertura do menu principal, a resolução mobile de 375x667px e a exibição integral dos seis cards, sem sobreposição entre si ou pela barra de navegação fixa.
    [Tags]    menu_principal    responsividade    mobile    caixa_preta    ct10
    Ativar simulacao mobile
    Conferir todos os cards do menu