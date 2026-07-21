# Mapeamento da planilha SDAP para o sistema

| Coluna da planilha | Destino no sistema |
|---|---|
| STATUS / STATUS VIGÊNCIA | Situação informada; a situação efetiva é recalculada pela data |
| CONTRATO | Contrato — chave principal |
| PAG | PAG/Processo |
| EMPRESA | Empresa/Fornecedor |
| PREGÃO | Pregão/Contratação |
| ITEM PREGÃO | Item do contrato |
| CÓD. TDV | Código TDV do item |
| NOMENCLATURA | Nomenclatura do item |
| TIPO | Modelo/tipo/descrição |
| QTD EMPENHADO | Quantidade do item, empenho e distribuição |
| ANO EMPENHO | Ano da NE |
| EMPENHO | Nota de empenho |
| DATA NE | Data da NE |
| AÇÃO ORÇAMENTÁRIA | Ação orçamentária do empenho |
| PTRES | PTRES do empenho |
| ORIGEM CRÉDITO | Origem do crédito |
| PI | Plano Interno |
| VALOR UNITÁRIO | Valor unitário do item |
| VALOR TOTAL | Valor do empenho/distribuição; soma forma o valor do contrato |
| OM TERMO DE REFERÊNCIA | OM do termo de referência |
| OM DESTINO | OM destino da ordem/distribuição |
| GESTOR | Responsável/gestor |
| SUPLENTE | Responsável/suplente |
| ASSINATURA DO CONTRATO | Assinatura e início da vigência |
| VIGÊNCIA FINAL CONTRATO | Fim da vigência |
| ASSINATURA DA ORD. FORNECIMENTO | Emissão/assinatura da OF |
| PRAZO DE ENTREGA | Prazo da ordem |
| OFÍCIO ORDEM FORNECIMENTO À OM | Referência de ofício/SIGAD |
| ENTREGUES? | Situação reportada da entrega |
| VIATURAS ENTREGUES EM | Data/texto da entrega |
| DIAS P/ VENCER | Não importada; calculada pelo sistema |
| STATUS ENTREGA | Situação da ordem/entrega |

## Regras de consolidação

- Contrato: agrupado por número.
- Item: contrato + item do pregão + TDV + descrição.
- Empenho: contrato + item + número da NE.
- Ordem/distribuição: contrato + item + empenho + OM destino + referência do ofício.
- Entrega: criada quando a linha está concluída, tem OM destino e data reconhecível.
