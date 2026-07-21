# Arquitetura técnica

## Componentes

- **Aplicação web:** Django 5.2 LTS;
- **servidor WSGI:** Waitress, usado em ambientes containerizados e no Render;
- **arquivos estáticos:** WhiteNoise;
- **banco local/teste:** SQLite;
- **banco multiusuário recomendado:** PostgreSQL;
- **relatórios PDF:** ReportLab;
- **XLSX:** leitor e escritor interno baseados no formato Open XML;
- **autenticação:** Django Auth e grupos;
- **auditoria:** sinais de criação, alteração, exclusão, login, importação e exportação.

## Entidades principais

```text
Empresa ─── Contrato ─── Item
                 │          │
                 ├── Empenho┘
                 │
                 ├── Ordem de fornecimento ─── Entrega
                 ├── Alteração contratual
                 ├── PAAI/Processo administrativo
                 └── Documento
```

Organizações Militares e Responsáveis são cadastros compartilhados.

## Importação

A importação opera em duas fases:

1. leitura e normalização para JSON no lote de prévia;
2. transação atômica após confirmação.

Se ocorrer erro durante a confirmação, a transação é revertida. A prévia não grava contratos.

## Escalabilidade

SQLite é adequado para validação e poucos acessos. Para uso simultâneo, PostgreSQL é recomendado. Documentos ficam fora do banco, na pasta/volume `media`, e devem ser copiados juntamente com o banco.
