*** Settings ***
Documentation     CT10 - Verificar a exibição do menu principal em resolução mobile.
...               Salva uma captura de tela diretamente na pasta CT10 a cada rolagem até um card.
Library           SeleniumLibrary    run_on_failure=NONE


*** Variables ***
${BROWSER}                     Chrome
${URL_BASE}                    http://localhost/mykeeper
${URL_LOGIN}                   ${URL_BASE}/usuario_login
${USUARIO_VALIDO}              user@user.com
${SENHA_VALIDA}                 Teste12345*
${TIMEOUT}                     10s

# Login
${CAMPO_LOGIN_USUARIO}         id:email
${CAMPO_LOGIN_SENHA}           id:senha
${BOTAO_ENTRAR}                css:button[type="submit"]
${ELEMENTO_POS_LOGIN}          id:logoffButtonLink
${TITULO_MENU_PRINCIPAL}       xpath://h1[contains(., 'Bem-vindo ao')]

# Simulação mobile
${LARGURA_MOBILE}              375
${ALTURA_MOBILE}               667
${CARD_HOME}                   css:.home-card
${BARRA_NAVEGACAO}             css:.sideNavBar
@{NOMES_CARDS}                 Meus Produtos    Estoque    Lista de Compras    Receitas    Categorias    Suporte


*** Keywords ***
Abrir o navegador
    Open Browser    ${URL_LOGIN}    ${BROWSER}
    Maximize Browser Window

Abrir o navegador e fazer login
    Abrir o navegador
    Realizar login    ${USUARIO_VALIDO}    ${SENHA_VALIDA}

Realizar login
    [Arguments]    ${usuario}    ${senha}
    Wait Until Element Is Visible    ${CAMPO_LOGIN_USUARIO}    timeout=${TIMEOUT}
    Input Text        ${CAMPO_LOGIN_USUARIO}    ${usuario}
    Input Password    ${CAMPO_LOGIN_SENHA}      ${senha}
    Click Element     ${BOTAO_ENTRAR}
    Wait Until Page Contains Element    ${ELEMENTO_POS_LOGIN}       timeout=${TIMEOUT}
    Wait Until Element Is Visible       ${TITULO_MENU_PRINCIPAL}    timeout=${TIMEOUT}

Ativar simulacao mobile
    ${selenium}=   Get Library Instance    SeleniumLibrary
    ${driver}=     Evaluate    $selenium.driver
    ${metricas}=   Evaluate    {"width": ${LARGURA_MOBILE}, "height": ${ALTURA_MOBILE}, "deviceScaleFactor": 1, "mobile": True}
    Call Method    ${driver}    execute_cdp_cmd    Emulation.setDeviceMetricsOverride    ${metricas}
    ${largura}=    Execute Javascript    return window.innerWidth
    ${altura}=     Execute Javascript    return window.innerHeight
    Should Be Equal As Integers    ${largura}    ${LARGURA_MOBILE}
    Should Be Equal As Integers    ${altura}     ${ALTURA_MOBILE}

Conferir todos os cards do menu
    ${quantidade}=    Get Element Count    ${CARD_HOME}
    Should Be Equal As Integers    ${quantidade}    6
    FOR    ${nome}    IN    @{NOMES_CARDS}
        ${card}=    Set Variable    xpath://div[contains(@class, 'home-card') and .//h3[normalize-space()='${nome}']]
        Wait Until Element Is Visible    ${card}    timeout=${TIMEOUT}
        ${titulo}=    Get Text    xpath://div[contains(@class, 'home-card') and .//h3[normalize-space()='${nome}']]//h3
        Should Be Equal As Strings    ${titulo}    ${nome}
        ${elemento}=    Get WebElement    ${card}
        Execute Javascript
        ...    arguments[0].scrollIntoView({block: 'center'});
        ...    ARGUMENTS
        ...    ${elemento}
        Capture Page Screenshot    ${CURDIR}${/}ct10_scroll_${nome}.png
        ${completo}=    Execute Javascript
        ...    return (function(card) { const rect = card.getBoundingClientRect(); return rect.top >= 0 && rect.bottom <= window.innerHeight + 1 && rect.left >= 0 && rect.right <= window.innerWidth + 1; })(arguments[0])
        ...    ARGUMENTS
        ...    ${elemento}
        Should Be True    ${completo}    O card "${nome}" não está totalmente visível na tela mobile.
        ${barra}=    Get WebElement    ${BARRA_NAVEGACAO}
        ${sem_sobreposicao_barra}=    Execute Javascript
        ...    return (function(card, bar) { const cardRect = card.getBoundingClientRect(), barRect = bar.getBoundingClientRect(); if (getComputedStyle(bar).position !== 'fixed') return true; return cardRect.right <= barRect.left || barRect.right <= cardRect.left || cardRect.bottom <= barRect.top || barRect.bottom <= cardRect.top; })(arguments[0], arguments[1])
        ...    ARGUMENTS
        ...    ${elemento}
        ...    ${barra}
        Should Be True    ${sem_sobreposicao_barra}    O card "${nome}" está sobreposto pela barra de navegação mobile.
    END
    ${sem_sobreposicao}=    Execute Javascript
    ...    return [...document.querySelectorAll('.home-card')].every((a, i, cards) => cards.slice(i + 1).every(b => { const x = a.getBoundingClientRect(), y = b.getBoundingClientRect(); return x.right <= y.left || y.right <= x.left || x.bottom <= y.top || y.bottom <= x.top; }))
    Should Be True    ${sem_sobreposicao}    Os cards do menu principal estão sobrepostos.

Fechar o navegador
    Capture Page Screenshot
    Close Browser