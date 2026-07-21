# Manual de Instalação e Utilização
## Gestão de Contratos — SDAP

**Versão:** 1.0  
**Arquitetura:** sistema web multiusuário  
**Banco para teste/local:** SQLite  
**Banco recomendado para uso institucional simultâneo:** PostgreSQL

---

## 1. O que significa “instalar no Windows”

O sistema é instalado **uma única vez** em um computador ou servidor que ficará ligado durante o expediente. Os demais usuários não precisam instalar o programa: acessam pelo navegador usando o endereço do servidor na rede interna.

- No próprio servidor: `http://127.0.0.1:8000`
- Em outro computador da rede: `http://IP_DO_SERVIDOR:8000`

A publicação na rede, abertura de porta e escolha do servidor devem ser validadas pela área de Tecnologia da Informação e Segurança da Informação da organização.

---

## 2. Escolha do modo de instalação

### 2.1 Teste individual ou validação inicial

Use Windows + SQLite. É a instalação mais simples e adequada para conhecer o sistema, revisar telas e importar uma cópia da planilha.

### 2.2 Uso por vários militares

Use PostgreSQL, preferencialmente por Docker ou em servidor administrado pela TI. O PostgreSQL lida melhor com gravações simultâneas, cópias de segurança e crescimento da base.

### 2.3 Acesso externo pela internet

Não publique diretamente a porta 8000 na internet. Para acesso externo são necessários HTTPS, proxy reverso, firewall, política de senhas, atualização e autorização institucional.

---

## 3. Instalação no Windows — modo simples

### 3.1 Pré-requisitos

1. Windows 10, Windows 11 ou Windows Server;
2. Python 3.10 ou superior, 64 bits;
3. conexão à internet durante a instalação das dependências;
4. permissão para executar PowerShell e criar uma pasta local;
5. para acesso em rede, autorização para liberar a porta TCP 8000 no firewall.

Ao instalar o Python, marque **Add Python to PATH**.

### 3.2 Pasta recomendada

Extraia o pacote para:

```text
C:\GestaoContratosSDAP
```

Evite inicialmente pastas sincronizadas pelo OneDrive, pendrives e compartilhamentos de rede. O banco e os documentos devem permanecer no computador servidor.

### 3.3 Executar o instalador

Clique duas vezes em:

```text
INSTALAR_WINDOWS.bat
```

O instalador:

1. verifica o Python;
2. cria o ambiente isolado `.venv`;
3. instala as dependências;
4. cria o arquivo de configuração `.env`;
5. gera uma chave secreta;
6. identifica um IP provável da rede;
7. cria o banco e as tabelas;
8. cria os grupos de permissões;
9. pergunta se deseja criar o administrador.

Guarde o usuário e a senha do administrador em local seguro.

### 3.4 Iniciar o servidor

Para permitir acesso na rede interna, execute:

```text
INICIAR_SERVIDOR_WINDOWS.bat
```

Para permitir acesso somente no próprio computador, execute:

```text
INICIAR_LOCAL_WINDOWS.bat
```

A janela do servidor deverá permanecer aberta. Para parar o sistema, use `Ctrl+C` ou feche a janela.

### 3.5 Liberar o firewall

A liberação deve ser realizada por administrador autorizado. Exemplo de regra no PowerShell elevado:

```powershell
New-NetFirewallRule -DisplayName "Gestão de Contratos SDAP" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow
```

Antes de executar, confirme a autorização da TI. Em redes segmentadas, o firewall do Windows pode não ser o único controle necessário.

### 3.6 Descobrir o IP do servidor

No Prompt de Comando:

```cmd
ipconfig
```

Procure por **Endereço IPv4**, por exemplo `10.10.20.35`. Os usuários acessariam:

```text
http://10.10.20.35:8000
```

Caso o IP mude, solicite à TI um endereço reservado/fixo e atualize `DJANGO_ALLOWED_HOSTS` no arquivo `.env`.

---

## 4. Configuração do arquivo `.env`

O arquivo `.env` contém configurações locais. Exemplo para rede interna:

```env
DJANGO_SECRET_KEY=chave-longa-gerada-pelo-instalador
DJANGO_DEBUG=0
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost,10.10.20.35
DB_ENGINE=sqlite
SQLITE_PATH=db.sqlite3
```

Para uso definitivo, defina `DJANGO_DEBUG=0`.

Não compartilhe o arquivo `.env`, pois ele contém informações sensíveis. Nunca reutilize a chave de exemplo.

---

## 5. Instalação com Docker e PostgreSQL

### 5.1 Pré-requisitos

- Docker Desktop ou Docker Engine;
- Docker Compose;
- autorização da equipe de infraestrutura.

### 5.2 Preparação

Copie `.env.example` para `.env` e altere:

```env
DJANGO_SECRET_KEY=UMA-CHAVE-ALEATORIA-LONGA
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost,IP_DO_SERVIDOR
POSTGRES_DB=gestao_contratos
POSTGRES_USER=gestao_contratos
POSTGRES_PASSWORD=SENHA_FORTE_EXCLUSIVA
```

Para criar o primeiro administrador automaticamente apenas na primeira implantação, acrescente temporariamente:

```env
INITIAL_ADMIN_USERNAME=administrador
INITIAL_ADMIN_PASSWORD=SENHA_TEMPORARIA_FORTE
INITIAL_ADMIN_EMAIL=
```

Após confirmar o acesso, remova `INITIAL_ADMIN_PASSWORD` do arquivo e altere a senha pelo sistema.

### 5.3 Inicialização

```bash
docker compose up -d --build
```

Acompanhar logs:

```bash
docker compose logs -f web
```

Parar:

```bash
docker compose down
```

Não utilize `docker compose down -v` sem intenção explícita, pois a opção `-v` remove os volumes de dados.

---

## 6. Primeiro acesso e perfis

Acesse `/admin/` com o administrador para criar usuários e atribuir grupos.

### Administrador

Gerencia usuários, permissões, configurações e todos os registros.

### Gestor

Gerencia contratos, importações e registros administrativos.

### Fiscal

Consulta contratos e atualiza ordens, entregas e documentos operacionais.

### Consulta

Somente leitura e emissão de relatórios.

Passos para novo usuário:

1. abra **Administração**;
2. selecione **Usuários**;
3. crie usuário e senha;
4. informe nome e sobrenome;
5. selecione um dos grupos;
6. salve;
7. teste o acesso com o usuário criado.

Não conceda perfil de administrador apenas para permitir edição comum.

---

## 7. Fluxo recomendado de utilização

### 7.1 Cadastros básicos

Revise Empresas, Organizações Militares e Responsáveis.

### 7.2 Contrato

Cadastre número, empresa, objeto, PAG, pregão, legislação, responsáveis, assinatura, vigência e valores.

### 7.3 Itens

Inclua item do pregão, código TDV, nomenclatura, modelo/tipo, quantidade e valor unitário.

### 7.4 Empenhos

Registre número da NE, ano, data, item, quantidade, valor, Ação Orçamentária, PTRES, origem do crédito e PI.

### 7.5 Ordens de fornecimento

Relacione contrato, item, empenho, OM destino, assinatura, prazo, quantidade, valor e referência do ofício/SIGAD.

### 7.6 Entregas

Registre data, quantidade, nota fiscal, aceite, responsável e ocorrências. O saldo da ordem é atualizado automaticamente.

### 7.7 Alterações contratuais

Registre termo aditivo, reajuste, repactuação, apostilamento, prorrogação ou supressão.

### 7.8 PAAI

Registre número, motivo, abertura, prazo, andamento, resultado/sanção e observações.

### 7.9 Documentos

Anexe contrato, empenho, OF, relatório, notificação, aditivo, nota fiscal ou garantia. O limite padrão é 10 MB por arquivo.

---

## 8. Importação da planilha SDAP

Acesse **Importar planilha** no menu Administração.

1. selecione o arquivo `.xlsx`;
2. mantenha a aba `Planilha1`, salvo se o arquivo tiver outro nome;
3. clique em **Gerar prévia**;
4. confira totais, erros e alertas;
5. analise as primeiras linhas normalizadas;
6. confirme somente depois da revisão.

### Regras aplicadas

- linhas do mesmo número de contrato são agrupadas;
- empresa e dados principais não são duplicados;
- itens são separados por item do pregão, TDV e descrição;
- empenhos são consolidados por contrato, item e número da NE;
- cada OM destino gera sua ordem/distribuição;
- entrega marcada como concluída gera registro quando houver data válida e OM destino;
- linhas sem OM destino ficam como alerta e não recebem uma OM inventada;
- a coluna “Dias p/ vencer” é ignorada e recalculada pelo sistema;
- nenhum dado é gravado durante a prévia.

A importação pode atualizar registros com as mesmas chaves. Faça backup antes de importar uma planilha revisada sobre uma base já utilizada.

---

## 9. Relatórios

Na tela de Contratos estão disponíveis:

- **Excel/XLSX:** relatório estruturado e filtrável;
- **PDF:** relatório para leitura e impressão;
- **CSV:** integração com outras ferramentas.

Os relatórios refletem o banco no momento da emissão.

---

## 10. Backup e restauração

### 10.1 SQLite

Execute:

```text
BACKUP_WINDOWS.bat
```

O arquivo será criado na pasta `backups`. O backup contém:

- cópia consistente do banco `db.sqlite3`;
- pasta de documentos `media`.

Copie o ZIP para local protegido e autorizado. Não mantenha todas as cópias no mesmo disco do servidor.

### 10.2 Restaurar SQLite

1. pare o servidor;
2. faça uma cópia do estado atual;
3. extraia `db.sqlite3` para a raiz do projeto;
4. extraia a pasta `media` preservando a estrutura;
5. execute `INICIAR_SERVIDOR_WINDOWS.bat`;
6. confira contratos e documentos.

### 10.3 PostgreSQL

Exemplo de backup pelo Docker:

```bash
docker compose exec -T db pg_dump -U gestao_contratos -d gestao_contratos -Fc > backup_postgres.dump
```

Faça também backup do volume/pasta de documentos. A restauração deve ser validada periodicamente em ambiente separado.

---

## 11. Atualização do sistema

Antes de substituir arquivos:

1. gere backup;
2. pare o servidor;
3. preserve `.env`, banco e pasta `media`;
4. substitua o código;
5. execute `ATUALIZAR_SISTEMA_WINDOWS.bat`;
6. execute os testes;
7. reinicie o servidor.

Comando manual de validação:

```bash
python manage.py check
python manage.py test
```

---

## 12. Segurança e limitações

- O sistema não substitui as regras de instrução processual nem os sistemas corporativos oficiais.
- A informação deve ser conferida por usuário responsável antes de uso administrativo.
- Não exponha a porta 8000 diretamente à internet.
- Em ambiente definitivo, use `DJANGO_DEBUG=0`.
- Configure HTTPS quando houver acesso além de rede controlada.
- Restrinja administradores.
- Atualize dependências após avaliação e testes.
- Faça backup do banco e dos documentos.
- Registre a solução no processo interno de autorização/homologação de TI, quando aplicável.

---

## 13. Solução de problemas

### “Python não encontrado”

Reinstale o Python marcando **Add Python to PATH** e reinicie o Windows.

### “A página não abre em outro computador”

Verifique:

1. servidor em execução;
2. IP correto;
3. mesma rede ou rota permitida;
4. porta 8000 liberada;
5. IP incluído em `DJANGO_ALLOWED_HOSTS`;
6. bloqueios de rede institucionais.

### “DisallowedHost”

Inclua o IP/nome do servidor no `.env`, por exemplo:

```env
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost,10.10.20.35
```

Reinicie o servidor.

### “Planilha não reconhecida”

Confirme o formato `.xlsx`, o nome da aba e as colunas obrigatórias `CONTRATO` e `EMPRESA`. Baixe o modelo pelo sistema para comparar os cabeçalhos.

### Documento não abre

Confira se a pasta `media` foi preservada e se o arquivo existe no servidor.
