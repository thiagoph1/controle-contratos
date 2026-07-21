# Manual de Instalação e Utilização
## Gestão de Contratos — SDAP

**Versão:** 1.0  
**Arquitetura:** sistema web multiusuário  
**Banco para teste/local:** SQLite  
**Banco recomendado para uso institucional simultâneo:** PostgreSQL

---

## 1. Visão geral

O sistema pode ser executado localmente para validação ou implantado em ambientes cloud como Render. A opção recomendada para produção é usar PostgreSQL com o container Docker fornecido.

### Ambientes suportados

- Teste local com SQLite;
- Docker Compose com PostgreSQL;
- Deploy no Render com PostgreSQL gerenciado.

---

## 2. Execução local

### 2.1 Com SQLite

```bash
python manage.py migrate
python manage.py bootstrap_system --no-admin
python manage.py runserver
```

### 2.2 Com Docker Compose

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

---

## 3. Configuração do arquivo `.env`

Copie `.env.example` para `.env` e defina:

```env
DJANGO_SECRET_KEY=uma-chave-aleatoria-longa
DJANGO_DEBUG=0
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost
DB_ENGINE=sqlite
SQLITE_PATH=db.sqlite3
```

Para produção com PostgreSQL, use:

```env
DB_ENGINE=postgresql
DATABASE_URL=postgresql://usuario:senha@host:5432/gestao_contratos
```

---

## 4. Deploy no Render

O projeto já está preparado para implantação no Render por meio de `render.yaml`.

### Passos

1. Conecte este repositório ao Render.
2. Crie um banco PostgreSQL e associe a variável `DATABASE_URL` ao serviço web.
3. Defina as variáveis mínimas de ambiente:
   - `DJANGO_SECRET_KEY`
   - `DJANGO_DEBUG=0`
   - `DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com`
   - `DB_ENGINE=postgresql`
4. Faça o deploy; o container iniciará automaticamente com o script de entrada do projeto.

---

## 5. Primeiro acesso e perfis

Acesse `/admin/` com o usuário administrador criado na inicialização para gerenciar usuários e atribuir grupos.

### Administrador

Gerencia usuários, permissões, configurações e todos os registros.

### Gestor

Gerencia contratos, importações e registros administrativos.

### Fiscal

Consulta contratos e atualiza ordens, entregas e documentos operacionais.

### Consulta

Somente leitura e emissão de relatórios.

---

## 6. Fluxo recomendado de utilização

### 6.1 Cadastros básicos

Revise Empresas, Organizações Militares e Responsáveis.

### 6.2 Contrato

Cadastre número, empresa, objeto, PAG, pregão, legislação, responsáveis, assinatura, vigência e valores.

### 6.3 Itens

Inclua item do pregão, código TDV, nomenclatura, modelo/tipo, quantidade e valor unitário.

### 6.4 Empenhos

Registre número da NE, ano, data, item, quantidade, valor, Ação Orçamentária, PTRES, origem do crédito e PI.

### 6.5 Ordens de fornecimento

Relacione contrato, item, empenho, OM destino, assinatura, prazo, quantidade, valor e referência do ofício/SIGAD.

### 6.6 Entregas

Registre data, quantidade, nota fiscal, aceite, responsável e ocorrências. O saldo da ordem é atualizado automaticamente.

### 6.7 Alterações contratuais

Registre termo aditivo, reajuste, repactuação, apostilamento, prorrogação ou supressão.

### 6.8 PAAI

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

```bash
python manage.py backup_system
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
5. reinicie o servidor;
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
5. execute os testes;
6. reinicie o servidor.

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

Verifique a instalação do Python 3.10+ e o ambiente virtual, ou reinstale o runtime conforme o ambiente de execução.

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
