# Testes automatizados — MyKeeper (Robot Framework + SeleniumLibrary)

Automação dos casos de teste CT02, CT09, CT10, CT12, CT17, CT18, CT19, CT20, CT25, CT26, CT27, CT31, CT32, CT33, CT34, CT35, CT36, CT37, CT38 e CT39. Autoria, conforme o histórico do git:

| Casos | Autor |
|---|---|
| CT02, CT09, CT10, CT12, CT39 | EmillyB-O |
| CT17, CT18, CT19, CT20, CT33 | Lucas |
| CT25, CT26, CT27, CT31, CT32 | Rodrigo Yuji |
| CT34, CT35, CT36, CT37, CT38 | GLebedieff |

Cada caso tem a sua pasta `CTnn/`, com 2 arquivos: o caso de teste e o `ctNN_resources.robot` (variáveis e keywords). O nome do arquivo de teste varia conforme o autor:
- `ctNN_testes.robot` em CT17 a CT20 e CT33 a CT38;
- `ctNN_teste.robot` em CT02, CT09, CT10, CT12, CT25 a CT32 e CT39.

## Pré-requisitos

- Python 3.10+ (testado com 3.14.8)
- Google Chrome (testado com 155)
- Brave, só para CT34 a CT38 (testado com Brave 1.98.60 / Chromium 156)
- Dependências num ambiente virtual (na pasta de trabalho):

```bash
python3 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

O `requirements.txt` instala Robot Framework 7.5, SeleniumLibrary 6.9.0 e Selenium 4.51.0. A biblioteca `String` (usada no CT18) já vem com o Robot Framework.

## Subir o MyKeeper

1. Configure o `.env` do MyKeeper (conexão com o banco).
2. No XAMPP, inicie o **Apache** e o **MySQL**.
3. Confirme que `http://localhost/mykeeper` abre no navegador.

## Pré-requisitos para rodar

Antes de rodar, confirme:

1. Apache e MySQL do XAMPP ligados, e o banco do MyKeeper criado e configurado no `.env`.
2. `http://localhost/mykeeper/usuario_login` abre (rotas sem `.php` funcionando). Se o sistema estiver em outro endereço ou porta, use `-v URL:http://...`.
3. A unidade de medida **"Quilo (Kg)"** existe na lista do cadastro de produto (usada por CT17, CT32, CT37 e CT38).
4. O botão "Compartilhar" da lista gera um link com `token=` (CT18). O domínio do link não importa: o teste reaproveita só a rota.
5. O CT18 precisa que `${URL}` seja `localhost` ou `https`: o teste lê o link copiado pela área de transferência do navegador, que só existe nesses endereços. Com `http://<IP da rede>` ele falha.
6. Google Chrome instalado (e o Brave, para CT34 a CT38). Na primeira execução, e sempre que o navegador for atualizado, o Selenium Manager precisa de internet para baixar o ChromeDriver.
7. O `.venv` ativo antes do `robot` (`source .venv/bin/activate`). `robot --version` deve mostrar 7.5.
8. Internet disponível, caso o cadastro do sistema consulte o CEP (`80215-901`) num serviço externo.

Ajustes opcionais, sem editar os arquivos: `-v TIMEOUT:20s` para máquinas lentas (o padrão é 10s) e `-v HEADLESS:True` para rodar sem janela.

Cuidados:
- Os casos validam os textos exatos das mensagens do sistema, como "Cadastro realizado com êxito", "Senha atualizada com sucesso", "Lista não encontrada." e "Digite uma mensagem antes de enviar.". Se um texto mudar, o caso falha.
- No CT18, o token alterado é o último caractere do link. Se o formato do link mudar, revise esse passo.

**Casos que criam a própria conta:** CT17, CT18, CT19, CT20, CT33, CT34, CT35, CT36, CT37 e CT38. Eles cadastram os dados pela interface, com um usuário novo (`teste_<número>_ctNN@teste.com`, senha `Senha@123`). Para esses casos não é preciso cadastrar nada antes, exceto a unidade "Quilo (Kg)" usada por CT17, CT37 e CT38. Eles rodam em qualquer ordem e quantas vezes quiser. Os dados criados ficam no banco, porque não há limpeza automática.

**Casos que usam conta e dados já existentes:**
- CT09, CT10, CT12, CT25, CT26, CT27, CT31, CT32 e CT39 exigem os dados listados em [Dados que precisam existir antes de rodar](#dados-que-precisam-existir-antes-de-rodar).
- O CT02 não usa conta: ele testa o próprio cadastro.

| Caso | Dados criados pelo próprio teste |
|---|---|
| CT17 | usuário, categoria "Mercearia CT17", produto "Arroz CT17" (Quilo (Kg)), lista "Lista CT17" |
| CT18 | usuário, lista "Lista CT18" |
| CT19 | usuário (a senha muda para `NovaSenha@456`) |
| CT20 | usuário, ticket "Ticket CT20" |
| CT33 | usuário (a senha não deve mudar) |
| CT34 | usuário |
| CT35 | usuário, ticket "Ticket CT35" com uma mensagem |
| CT36 | usuário, lista "Lista CT36" (fica arquivada) |
| CT37 | usuário, categoria "Laticinios CT37", produto "Queijo CT37", estoque "Geladeira CT37" (o item é excluído) |
| CT38 | usuário, categoria "Laticinios CT38", produto "Queijo CT38", estoque "Geladeira CT38" com o item alterado |

### Pré-requisitos do sistema por caso de teste

Os dados marcados como "criado pelo teste" são cadastrados automaticamente pelo Suite Setup do caso. Os marcados como "preexistente" precisam estar no sistema antes de rodar. Os marcados como "A confirmar manualmente" não puderam ser verificados sem ler o código do sistema.

Todos os casos dependem de:
- Apache e MySQL ligados;
- banco do MyKeeper criado, com o `.env` configurado (conteúdo do `.env`: A confirmar manualmente);
- `${URL}` = `http://localhost/mykeeper` respondendo;
- Google Chrome, com internet na primeira execução para baixar o ChromeDriver;
- internet, caso o cadastro consulte o CEP num serviço externo (A confirmar manualmente).

#### CT02 — Impedir cadastro com e-mail inválido
- **Conta de usuário:** não precisa. O caso não faz login: ele parte da página inicial ("Começar agora", `id:startNowButton`), abre o cadastro (`id:createAccount`) e preenche:
  - "Nome": `Usuário Válido`;
  - "E-mail": `usuario.invalido.com` (sem @);
  - "CEP": `81280080`;
  - "Senha": `Teste12345678*`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada. O teste não cria nada se o sistema bloquear o cadastro. Se não bloquear, fica uma conta com o e-mail `usuario.invalido.com`.
- **Configuração/ambiente:**
  - a comum a todos os casos;
  - abre o Chrome padrão em `${URL_BASE}` = `http://localhost/mykeeper`;
  - espera que o campo CEP formate o valor como `81280-080`;
  - espera exatamente a mensagem "ERRO! Digite um e-mail válido." em `id:error`;
  - salva os screenshots com nome fixo dentro da própria pasta (`CT02/ct02_01_pagina_inicial.png` a `ct02_06_fim.png`), sobrescrevendo os da execução anterior.

#### CT09 — Inserir item no estoque com quantidade negativa
- **Conta de usuário:** preexistente. Conta fixa `user@user.com` / `Teste12345*` (`${USUARIO_VALIDO}` / `${SENHA_VALIDA}`). O teste não cadastra usuário.
- **Categoria:** não precisa (a do produto já existente).
- **Produto:** preexistente. Produto com o nome exato **"Arroz"** (`${PRODUTO_ALVO}`), na conta `user@user.com`.
- **Estoque / itens de estoque:** preexistente. Estoque com o nome exato **"Despensa"** (`${ESTOQUE_ALVO}`). O caso abre "Novo Item", filtra "Arroz" e tenta adicionar com quantidade `-1`. Se o sistema aceitar, esse item fica no estoque.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `user@user.com` / `Teste12345*`, o estoque "Despensa" e o produto "Arroz", na mesma conta.
- **Configuração/ambiente:**
  - a comum a todos os casos;
  - abre o Chrome padrão;
  - aceita como bloqueio um alerta do navegador ou um texto na página que contenha "maior do que 0".

#### CT10 — Exibir todos os cards do menu principal em mobile
- **Conta de usuário:** preexistente. Conta fixa `user@user.com` / `Teste12345*`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `user@user.com` / `Teste12345*`. O teste não cria nada. Ele confere que a página inicial logada mostra o título "Bem-vindo ao" e exatamente 6 cards: "Meus Produtos", "Estoque", "Lista de Compras", "Receitas", "Categorias" e "Suporte".
- **Configuração/ambiente:**
  - a comum a todos os casos;
  - abre o Chrome padrão e simula a tela mobile 375x667 com um comando do DevTools (`execute_cdp_cmd`), que só existe em navegadores baseados em Chromium;
  - salva um screenshot por card dentro da própria pasta (`CT10/ct10_scroll_<card>.png`; alguns nomes têm espaço, como `ct10_scroll_Lista de Compras.png`), sobrescrevendo os anteriores.

#### CT12 — Impedir cadastro de categoria duplicada
- **Conta de usuário:** preexistente. Conta fixa `user@user.com` / `Teste12345*`.
- **Categoria:** preexistente. Pelo menos **uma categoria** na conta. O teste usa o nome da primeira linha da tabela de "Categorias de Produto" e tenta cadastrá-la de novo, com a descrição `...`.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `user@user.com` / `Teste12345*` com ao menos uma categoria. Se não houver nenhuma, o caso falha com "Não há uma categoria cadastrada para executar o teste de duplicidade.". Se o sistema aceitar a duplicata, uma categoria repetida fica na conta.
- **Configuração/ambiente:**
  - a comum a todos os casos;
  - abre o Chrome padrão;
  - espera exatamente a mensagem "ERRO! Categoria já cadastrada." em `id:error`;
  - salva os screenshots com nome fixo dentro da própria pasta (`CT12/ct12_01_login.png` a `ct12_06_alerta_duplicidade.png`).

#### CT17 — Adicionar item na lista de compras omitindo a quantidade do produto
- **Conta de usuário:** criado pelo teste. Um usuário novo a cada execução: `teste_<número>_ct17@teste.com` / `Senha@123`, nome "Usuario Teste CT17", CEP `80215-901`.
- **Categoria:** criado pelo teste. "Mercearia CT17" (descrição "Alimentos secos").
- **Produto:** criado pelo teste. "Arroz CT17", categoria "Mercearia CT17", unidade "Quilo (Kg)".
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** criado pelo teste. "Lista CT17", que começa **vazia**; o caso tenta adicionar o produto sem quantidade.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a unidade de medida "Quilo (Kg)" na lista do cadastro de produto (A confirmar manualmente).
- **Configuração/ambiente:** a comum a todos os casos. Resultado esperado hoje: falha (`bug_conhecido`).

#### CT18 — Acessar link de lista de compras compartilhado com link incorreto
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct18@teste.com` / `Senha@123`, nome "Usuario Teste CT18".
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** criado pelo teste. "Lista CT18", vazia (não precisa de itens).
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** criado pelo teste. O teste clica em "Compartilhar", lê o link copiado, troca o último caractere do token e abre o resultado numa janela anônima, sem login.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:**
  - a comum a todos os casos;
  - `${URL}` em `localhost` ou `https`, porque a área de transferência do navegador só funciona nesses endereços;
  - o link do botão "Compartilhar" precisa conter `token=`; o domínio, por exemplo ngrok, não importa.

#### CT19 — Alterar a senha de acesso com sucesso no perfil
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct19@teste.com` / `Senha@123`, nome "Usuario Teste CT19". Durante o caso a senha passa a ser `NovaSenha@456`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:** a comum a todos os casos.

#### CT20 — Tentar enviar mensagem em branco no chat de suporte
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct20@teste.com` / `Senha@123`, nome "Usuario Teste CT20".
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** criado pelo teste. "Ticket CT20" (descrição "Ticket criado pela automacao para testar o chat"); o caso abre o chat desse ticket.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:** a comum a todos os casos.

#### CT25 — Filtrar produtos por nome na adição de itens ao estoque
- **Conta de usuário:** preexistente. Conta fixa `teste@teste.com` / `Teste12345*` (`${USUARIO_VALIDO}` / `${SENHA_VALIDA}`). O teste não cadastra usuário.
- **Categoria:** não precisa.
- **Produto:** preexistente, na conta `teste@teste.com`: pelo menos um produto com "Queijo" no nome (o filtro não diferencia maiúsculas). A pré-condição do caso também pede produtos **sem** "Queijo", para o filtro ter o que esconder.
- **Estoque / itens de estoque:** preexistente. Estoque com o nome exato **"Geladeira Principal"** (`${ESTOQUE_ALVO}`), onde o caso abre "Novo Item" e usa o campo de busca de produto.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `teste@teste.com` / `Teste12345*`, o estoque "Geladeira Principal" e os produtos com e sem "Queijo" no nome, todos nessa conta. O teste não cria nada.
- **Configuração/ambiente:** a comum a todos os casos. Abre o Chrome padrão, sem opções. A URL é `${URL_BASE}` = `http://localhost/mykeeper`.

#### CT26 — Inserir item com data de validade vencida
- **Conta de usuário:** preexistente. Conta fixa `teste@teste.com` / `Teste12345*`.
- **Categoria:** não precisa (a do produto já existente).
- **Produto:** preexistente. Produto com o nome exato **"Iogurte Natural"** (`${PRODUTO_ALVO}`), encontrado pelo filtro "Iogurte".
- **Estoque / itens de estoque:** preexistente. Estoque **"Geladeira Principal"**. O caso tenta adicionar "Iogurte Natural" com quantidade `1` e validade de ontem, calculada pela data do computador. Se o sistema aceitar (defeito conhecido), esse item fica no estoque.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `teste@teste.com` / `Teste12345*`, o estoque "Geladeira Principal" e o produto "Iogurte Natural", na mesma conta.
- **Configuração/ambiente:** a comum a todos os casos. Abre o Chrome padrão. Usa a biblioteca `DateTime`, que já vem com o Robot Framework. Resultado esperado hoje, conforme o plano: falha (o sistema não avisa sobre a validade vencida).

#### CT27 — Abrir ticket de suporte sem descrição
- **Conta de usuário:** preexistente. Conta fixa `teste@teste.com` / `Teste12345*`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa existir antes. O caso preenche só o título "Dúvida de uso" e espera que o envio seja bloqueado; se o sistema aceitar, um ticket com esse título fica na conta.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `teste@teste.com` / `Teste12345*`.
- **Configuração/ambiente:** a comum a todos os casos. Abre o Chrome padrão. Aceita como bloqueio a mensagem "Por favor, preencha a descrição do ticket" na página ou a validação nativa do navegador.

#### CT31 — Logoff impede acesso a página protegida
- **Conta de usuário:** preexistente. Conta fixa `teste@teste.com` / `Teste12345*`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa. O caso só abre a página "Estoques" para guardar a URL protegida; a página precisa exibir o texto "Estoque".
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `teste@teste.com` / `Teste12345*`.
- **Configuração/ambiente:** a comum a todos os casos. Abre o Chrome padrão.

#### CT32 — Cadastrar produto com acentuação e cedilha no nome
- **Conta de usuário:** preexistente. Conta fixa `teste@teste.com` / `Teste12345*`.
- **Categoria:** preexistente. Categoria com o nome exato **"Grãos e Cereais"** (`${CATEGORIA_PRODUTO}`), selecionada pelo rótulo.
- **Produto:** criado pelo teste. "Pão de Açúcar Orgânico", categoria "Grãos e Cereais", unidade "Quilo (Kg)". Cada execução cadastra o produto de novo na conta `teste@teste.com`.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `teste@teste.com` / `Teste12345*`, a categoria "Grãos e Cereais" nessa conta e a unidade de medida "Quilo (Kg)" (A confirmar manualmente).
- **Configuração/ambiente:** a comum a todos os casos. Abre o Chrome padrão.
- **Observação:** o `[Documentation]` do caso cita a categoria **"Grãos"**, mas o teste seleciona **"Grãos e Cereais"**. Vale o nome usado pelo teste.

#### CT33 — Alterar senha informando a senha atual incorreta
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct33@teste.com` / `Senha@123`, nome "Usuario Teste CT33". O caso tenta trocar a senha para `NovaSenha@456` informando a senha atual errada `SenhaErrada@789`; a senha deve continuar `Senha@123`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:** a comum a todos os casos.

#### CT34 — Validar o acesso negado no login com senha incorreta
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct34@teste.com` / `Senha@123`, nome "Usuario Teste CT34", CEP `80215-901`. O caso tenta entrar com a senha errada `SenhaErrada@789`.
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:** a comum a todos os casos, **mais o navegador Brave** (ver a observação).
- **Observação:** o `ct34_resources.robot` força o navegador Brave num caminho do Windows. A variável `${CAMINHO_BRAVE}` (linha 7) vale `C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe` e é usada como `binary_location` em `Montar opcoes do navegador`. Em outra máquina é preciso ter o Brave exatamente nesse caminho, ou informar outro caminho. Sem isso, o caso falha antes de abrir o navegador com `NoSuchDriverException: Unable to obtain driver for chrome`. Testado: roda com `-v CAMINHO_BRAVE:/usr/bin/brave-browser` no Linux (Fedora, Brave RPM); no Windows, o caminho padrão do resources já serve. Comando no Linux: `robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT34/ct34_testes.robot`.

#### CT35 — Enviar mensagem valida no chat de um ticket de suporte
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct35@teste.com` / `Senha@123`, nome "Usuario Teste CT35".
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** criado pelo teste. "Ticket CT35" (descrição "Ticket criado pela automacao para testar o envio de mensagem"). O caso envia a mensagem "Mensagem CT35 enviada pela automacao" no chat desse ticket.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:** a comum a todos os casos, mais o Brave em `${CAMINHO_BRAVE}` (linha 7 do `ct35_resources.robot`). A observação do CT34 vale igual. Testado: roda com `-v CAMINHO_BRAVE:/usr/bin/brave-browser` no Linux (Fedora, Brave RPM); no Windows, o caminho padrão do resources já serve. Comando no Linux: `robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT35/ct35_testes.robot`.

#### CT36 — Arquivar uma lista de compras aberta
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct36@teste.com` / `Senha@123`, nome "Usuario Teste CT36".
- **Categoria:** não precisa.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** criado pelo teste. "Lista CT36", com status "Aberta" e sem itens. O caso a arquiva e ela fica com o status "Arquivada".
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** nada.
- **Configuração/ambiente:** a comum a todos os casos, mais o Brave em `${CAMINHO_BRAVE}` (linha 7 do `ct36_resources.robot`). A observação do CT34 vale igual. Testado: roda com `-v CAMINHO_BRAVE:/usr/bin/brave-browser` no Linux (Fedora, Brave RPM); no Windows, o caminho padrão do resources já serve. Comando no Linux: `robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT36/ct36_testes.robot`.

#### CT37 — Excluir um item do estoque e confirmar sua remocao da listagem
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct37@teste.com` / `Senha@123`, nome "Usuario Teste CT37".
- **Categoria:** criado pelo teste. "Laticinios CT37" (descrição "Itens da geladeira").
- **Produto:** criado pelo teste. "Queijo CT37", categoria "Laticinios CT37", unidade "Quilo (Kg)".
- **Estoque / itens de estoque:** criado pelo teste. Estoque "Geladeira CT37", com o item "Queijo CT37" na quantidade `2`. O caso exclui esse item.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a unidade de medida "Quilo (Kg)" na lista do cadastro de produto (A confirmar manualmente).
- **Configuração/ambiente:** a comum a todos os casos, mais o Brave em `${CAMINHO_BRAVE}` (linha 7 do `ct37_resources.robot`). A observação do CT34 vale igual. Testado: roda com `-v CAMINHO_BRAVE:/usr/bin/brave-browser` no Linux (Fedora, Brave RPM); no Windows, o caminho padrão do resources já serve. Comando no Linux: `robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT37/ct37_testes.robot`.

#### CT38 — Editar quantidade e data de validade de um item do estoque
- **Conta de usuário:** criado pelo teste. `teste_<número>_ct38@teste.com` / `Senha@123`, nome "Usuario Teste CT38".
- **Categoria:** criado pelo teste. "Laticinios CT38" (descrição "Itens da geladeira").
- **Produto:** criado pelo teste. "Queijo CT38", categoria "Laticinios CT38", unidade "Quilo (Kg)".
- **Estoque / itens de estoque:** criado pelo teste. Estoque "Geladeira CT38", com o item "Queijo CT38" na quantidade `2`. O caso altera a quantidade para `5` e a validade para `2030-12-31`.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a unidade de medida "Quilo (Kg)" na lista do cadastro de produto (A confirmar manualmente).
- **Configuração/ambiente:** a comum a todos os casos, mais o Brave em `${CAMINHO_BRAVE}` (linha 7 do `ct38_resources.robot`). A observação do CT34 vale igual. Testado: roda com `-v CAMINHO_BRAVE:/usr/bin/brave-browser` no Linux (Fedora, Brave RPM); no Windows, o caminho padrão do resources já serve. Comando no Linux: `robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT38/ct38_testes.robot`.

#### CT39 — Alterar nome da categoria Laticinios para Frios
- **Conta de usuário:** preexistente. Conta fixa `user@user.com` / `Teste12345*`.
- **Categoria:** preexistente. Categoria com o nome exato **"Laticínios"** (`${NOME_CATEGORIA_ORIGINAL}`), com o link "Editar" na tabela de "Categorias de Produto". O caso renomeia essa categoria para **"Frios"**.
- **Produto:** não precisa.
- **Estoque / itens de estoque:** não precisa.
- **Lista de compras:** não precisa.
- **Ticket de suporte:** não precisa.
- **Link de compartilhamento:** não precisa.
- **Já precisa existir no sistema (preexistente):** a conta `user@user.com` / `Teste12345*` e a categoria "Laticínios" nessa conta.
- **Configuração/ambiente:**
  - a comum a todos os casos;
  - abre o Chrome padrão;
  - espera exatamente a mensagem "SUCESSO! Categoria alterada com sucesso. Redirecionando..." em `id:error`;
  - salva os screenshots com nome fixo dentro da própria pasta (`CT39/ct39_01_login.png` a `ct39_06_fim.png`).
- **Observação:** o caso altera um dado preexistente. Depois de uma execução bem-sucedida, a categoria passa a se chamar "Frios" e "Laticínios" deixa de existir. Para rodar de novo, é preciso voltar o nome para "Laticínios" (ou cadastrá-la de novo).

### Dados que precisam existir antes de rodar

| Dado preexistente (nome exato) | Usado por |
|---|---|
| Conta `teste@teste.com` / `Teste12345*` | CT25, CT26, CT27, CT31, CT32 |
| Estoque "Geladeira Principal" (na conta `teste@teste.com`) | CT25, CT26 |
| Produto(s) com "Queijo" no nome, e produtos sem "Queijo" (na conta `teste@teste.com`) | CT25 |
| Produto "Iogurte Natural" (na conta `teste@teste.com`) | CT26 |
| Categoria "Grãos e Cereais" (na conta `teste@teste.com`) | CT32 |
| Conta `user@user.com` / `Teste12345*` | CT09, CT10, CT12, CT39 |
| Estoque "Despensa" (na conta `user@user.com`) | CT09 |
| Produto "Arroz" (na conta `user@user.com`) | CT09 |
| Pelo menos uma categoria (na conta `user@user.com`) | CT12 |
| Categoria "Laticínios" (na conta `user@user.com`; volta a ser necessária após cada execução, porque o caso a renomeia para "Frios") | CT39 |
| Unidade de medida "Quilo (Kg)" | CT17, CT32, CT37, CT38 |

Os casos CT02, CT18, CT19, CT20, CT33, CT34, CT35 e CT36 não dependem de nenhum dado preexistente. O CT02 não usa conta; os demais criam o próprio usuário e os dados de que precisam.

Dependência de ambiente específica: CT34, CT35, CT36, CT37 e CT38 precisam do navegador Brave em `${CAMINHO_BRAVE}`:
- No Windows, o caminho padrão do resources já serve: `C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe`.
- No Linux, rode com `-v CAMINHO_BRAVE:/usr/bin/brave-browser` (testado no Fedora, com o Brave RPM).

O CT10 usa um comando do DevTools que só existe em navegadores baseados em Chromium.

## Executar (um caso por vez)

Na raiz do repositório (a pasta que contém `CT02/`, `CT17/` etc.). Todas as pastas seguem o padrão `CTnn/`, sem espaços nem vírgulas, então os caminhos não precisam de aspas.

```bash
robot CT02/ct02_teste.robot
robot CT09/ct09_teste.robot
robot CT10/ct10_teste.robot
robot CT12/ct12_teste.robot
robot CT17/ct17_testes.robot
robot CT18/ct18_testes.robot
robot CT19/ct19_testes.robot
robot CT20/ct20_testes.robot
robot CT25/ct25_teste.robot
robot CT26/ct26_teste.robot
robot CT27/ct27_teste.robot
robot CT31/ct31_teste.robot
robot CT32/ct32_teste.robot
robot CT33/ct33_testes.robot
robot CT39/ct39_teste.robot
```

CT34 a CT38 abrem o Brave. No Windows, com o Brave no caminho padrão:

```bash
robot CT34/ct34_testes.robot
robot CT35/ct35_testes.robot
robot CT36/ct36_testes.robot
robot CT37/ct37_testes.robot
robot CT38/ct38_testes.robot
```

No Linux (testado no Fedora, com o Brave RPM):

```bash
robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT34/ct34_testes.robot
robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT35/ct35_testes.robot
robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT36/ct36_testes.robot
robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT37/ct37_testes.robot
robot -v CAMINHO_BRAVE:/usr/bin/brave-browser CT38/ct38_testes.robot
```

Cada comando abre o navegador, executa o caso e fecha o navegador. Os casos que usam conta fixa só passam com os dados de [Dados que precisam existir antes de rodar](#dados-que-precisam-existir-antes-de-rodar). Falhas esperadas, conforme o plano de teste:
- o CT17 aponta um defeito conhecido do sistema (tag `bug_conhecido`);
- o CT26 também deve falhar, porque o sistema não avisa sobre a validade vencida.

## Resultado

O Robot grava o resultado na pasta onde o comando foi executado. Abra o `log.html` no navegador; ao lado dele ficam o `report.html`, o `output.xml` e os screenshots (`selenium-screenshot-*.png`). Cada nova execução sobrescreve o `log.html` anterior.

CT02, CT10, CT12 e CT39 também gravam screenshots com nome fixo dentro da própria pasta `CTnn/`, sobrescrevendo os da execução anterior.

## Observações para os autores

Pontos que dependem de quem escreveu cada caso, para alinharmos juntos:

1. **Contas fixas.**
   - CT25, CT26, CT27, CT31 e CT32 usam a conta `teste@teste.com` / `Teste12345*`.
   - CT09, CT10, CT12 e CT39 usam a conta `user@user.com` / `Teste12345*`.
   - Quem rodar precisa ter essas contas e os dados do resumo no banco local. Uma alternativa seria esses casos criarem a própria conta no Suite Setup, como CT17 a CT20 e CT33 a CT38.
2. **CT32:** o `ct32_resources.robot` tem a keyword `Produto deve aparecer na lista com o nome correto`, com mensagens de falha próprias. O `ct32_teste.robot` não a chama; ele faz a conferência direto no corpo do teste. O `[Documentation]` cita a categoria "Grãos", e o teste usa "Grãos e Cereais".
3. **CT39:** o caso renomeia "Laticínios" para "Frios", então só roda de novo depois que o nome original for restaurado.
4. **Pastas:** os casos CT02, CT09, CT10, CT12 e CT39 já estão em pastas no padrão `CTnn/`. Fica só a diferença no nome do arquivo de teste (`ctNN_teste.robot` × `ctNN_testes.robot`), que não impede a execução.
5. **Arquivos gerados no repositório:** várias pastas `CTnn/` têm `log.html`, `output.xml`, `report.html` e screenshots versionados, e o `.gitignore` atual não os ignora. Os screenshots com nome fixo de CT02, CT10, CT12 e CT39 mudam a cada execução. Vale decidirmos juntos se esses arquivos ficam no repositório ou entram no `.gitignore`.
