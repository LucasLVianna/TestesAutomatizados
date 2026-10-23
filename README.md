# Testes automatizados — MyKeeper (Robot Framework + SeleniumLibrary)

Automação dos casos de teste CT17, CT18, CT19, CT20 e CT33. Cada caso tem a sua pasta, com 2 arquivos: `ctNN_testes.robot` (o caso de teste) e `ctNN_resources.robot` (variáveis e keywords).

## Pré-requisitos

- Python 3.10+ (testado com 3.14.8)
- Google Chrome (testado com 155)
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
3. A unidade de medida **"Quilo (Kg)"** existe na lista do cadastro de produto (usada pelo CT17).
4. O botão "Compartilhar" da lista gera um link com `token=` (CT18). O domínio do link não importa: o teste reaproveita só a rota.
5. O CT18 precisa que `${URL}` seja `localhost` ou `https`: o teste lê o link copiado pela área de transferência do navegador, que só existe nesses endereços. Com `http://<IP da rede>` ele falha.
6. Google Chrome instalado. Na primeira execução, e sempre que o Chrome for atualizado, o Selenium Manager precisa de internet para baixar o ChromeDriver.
7. O `.venv` ativo antes do `robot` (`source .venv/bin/activate`). `robot --version` deve mostrar 7.5.
8. Internet disponível, caso o cadastro do sistema consulte o CEP (`80215-901`) num serviço externo.

Ajustes opcionais, sem editar os arquivos: `-v TIMEOUT:20s` para máquinas lentas (o padrão é 10s) e `-v HEADLESS:True` para rodar sem janela.

Cuidados:
- Os casos validam os textos exatos das mensagens do sistema, como "Cadastro realizado com êxito", "Senha atualizada com sucesso", "Lista não encontrada." e "Digite uma mensagem antes de enviar.". Se um texto mudar, o caso falha.
- No CT18, o token alterado é o último caractere do link. Se o formato do link mudar, revise esse passo.

Cada caso cria os próprios dados pela interface, com um usuário novo (`teste_<número>_ctNN@teste.com`, senha `Senha@123`). Não é preciso cadastrar nada antes, e os casos rodam em qualquer ordem e quantas vezes quiser. Os dados criados ficam no banco, porque não há limpeza automática.

| Caso | Dados criados pelo próprio teste |
|---|---|
| CT17 | usuário, categoria "Mercearia CT17", produto "Arroz CT17" (Quilo (Kg)), lista "Lista CT17" |
| CT18 | usuário, lista "Lista CT18" |
| CT19 | usuário (a senha muda para `NovaSenha@456`) |
| CT20 | usuário, ticket "Ticket CT20" |
| CT33 | usuário (a senha não deve mudar) |

### Pré-requisitos do sistema por caso de teste

Os dados marcados como "criado pelo teste" são cadastrados automaticamente pelo Suite Setup do caso. Os marcados como "preexistente" precisam estar no sistema antes de rodar. Os marcados como "A confirmar manualmente" não puderam ser verificados sem ler o código do sistema.

Todos os casos dependem de:
- Apache e MySQL ligados;
- banco do MyKeeper criado, com o `.env` configurado (conteúdo do `.env`: A confirmar manualmente);
- `${URL}` = `http://localhost/mykeeper` respondendo;
- Google Chrome, com internet na primeira execução para baixar o ChromeDriver;
- internet, caso o cadastro consulte o CEP num serviço externo (A confirmar manualmente).

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

## Executar (um caso por vez)

Na raiz do repositório (a pasta que contém `CT17/`, `CT18/` etc.):

```bash
robot CT17/ct17_testes.robot
robot CT18/ct18_testes.robot
robot CT19/ct19_testes.robot
robot CT20/ct20_testes.robot
robot CT33/ct33_testes.robot
```

Cada comando abre o Chrome, executa o caso e fecha o navegador. O CT17 falha de propósito: ele aponta um defeito conhecido do sistema (tag `bug_conhecido`).

## Resultado

O Robot grava o resultado na pasta onde o comando foi executado. Abra o `log.html` no navegador; ao lado dele ficam o `report.html`, o `output.xml` e os screenshots (`selenium-screenshot-*.png`). Cada nova execução sobrescreve o `log.html` anterior.
