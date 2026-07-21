# Gestão de Contratos — SDAP

Sistema web multiusuário para cadastro, acompanhamento e auditoria de contratos, itens, notas de empenho, ordens de fornecimento, entregas, alterações contratuais, PAAI e documentos.

## Recursos entregues

- Painel com contratos, valores, vigências, atrasos, entregas e PAAI;
- contratos, empresas, OMs e responsáveis;
- itens do pregão e códigos TDV;
- empenhos com Ação Orçamentária, PTRES, origem do crédito e PI;
- ordens de fornecimento por OM destino;
- entregas, notas fiscais e aceite;
- aditivos, reajustes, repactuações, apostilamentos e prorrogações;
- PAAI/processos administrativos e sanções;
- documentos de até 10 MB;
- perfis Administrador, Gestor, Fiscal e Consulta;
- trilha de auditoria;
- importação da estrutura `SDAP_CONTRATOS_2026_v2.xlsx`, com prévia;
- exportação para XLSX, PDF e CSV;
- instalação Windows, Docker/PostgreSQL e backup SQLite.

## Início rápido no Windows

1. Instale Python 3.10 ou superior, marcando a opção de adicioná-lo ao PATH.
2. Extraia este projeto para uma pasta local, como `C:\GestaoContratosSDAP`.
3. Execute `INSTALAR_WINDOWS.bat`.
4. Crie o administrador quando solicitado.
5. Execute `INICIAR_SERVIDOR_WINDOWS.bat`.
6. Abra `http://127.0.0.1:8000` no servidor ou `http://IP_DO_SERVIDOR:8000` nos demais computadores da rede.

Leia `MANUAL_INSTALACAO_E_USO.md` antes de publicar o sistema na rede institucional.

## Comandos úteis

```bash
python manage.py test
python manage.py check
python manage.py seed_demo
python manage.py preview_import caminho/planilha.xlsx --sheet Planilha1
python manage.py backup_system
```

## Deploy no Railway

O projeto já está preparado para rodar no Railway com PostgreSQL e servir a aplicação via Waitress.

### Variáveis de ambiente mínimas

- `DJANGO_SECRET_KEY`: chave secreta forte.
- `DJANGO_DEBUG`: defina como `0` em produção.
- `DJANGO_ALLOWED_HOSTS`: adicione `localhost` e o domínio público do projeto, por exemplo `localhost,your-app.up.railway.app`.
- `DB_ENGINE=postgresql`
- `DATABASE_URL`: URL completa do PostgreSQL fornecida pelo Railway.
- `RAILWAY_PUBLIC_DOMAIN`: domínio público gerado pelo Railway.
- `PORT`: o Railway já preenche isso automaticamente.

### Passos

1. Conecte este repositório ao Railway.
2. Defina o serviço para usar o diretório da aplicação Django.
3. Adicione o PostgreSQL como serviço do Railway e copie a `DATABASE_URL` para a aplicação.
4. Defina as variáveis acima no painel do Railway.
5. Faça o deploy; o container iniciará automaticamente com o script de entrada do projeto.

## Observação sobre dados

Nenhum dado real da planilha fornecida acompanha o pacote. O arquivo foi utilizado apenas para validar a modelagem e o importador. A inclusão dos dados ocorre dentro do sistema, após login e revisão da prévia.
