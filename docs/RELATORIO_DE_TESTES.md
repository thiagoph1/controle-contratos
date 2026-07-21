# Relatório de testes

## Testes automatizados

Foram executados 11 testes, todos aprovados:

1. geração e leitura de XLSX;
2. prévia de importação;
3. importação transacional;
4. rejeição de planilha sem colunas obrigatórias;
5. cálculo de vigência;
6. autenticação obrigatória;
7. acesso ao painel;
8. bloqueio de edição para perfil de consulta;
9. renderização das principais telas e formulários;
10. exportações XLSX, PDF e CSV e geração do modelo de importação;
11. proteção e entrega autenticada de documentos anexados.

Comandos executados:

```bash
python manage.py test
python manage.py check
```

Resultado:

```text
Ran 11 tests
OK
System check identified no issues
```

## Teste com a planilha real fornecida

A planilha `SDAP_CONTRATOS_2026_v2.xlsx` foi lida e importada em banco descartável. A validação não alterou nem incorporou o arquivo real ao pacote.

Resultados principais:

- 30 contratos;
- valor consolidado R$ 45.004.271,00;
- 42 itens;
- 71 empenhos;
- 156 ordens/distribuições por OM;
- 48 entregas com destino e data vinculáveis;
- 0 erros impeditivos.
