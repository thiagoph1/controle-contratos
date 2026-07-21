# Resultado da validação da planilha fornecida

A planilha foi utilizada somente para testar a modelagem e o importador; os dados reais não integram este pacote.

Resultado da validação técnica:

- 165 linhas de dados;
- 30 contratos únicos;
- 21 empresas identificadas;
- valor total consolidado de R$ 45.004.271,00;
- 42 grupos de itens após consolidação;
- 71 combinações de empenho e item;
- 156 ordens/distribuições vinculáveis a OMs destino;
- 48 entregas com OM destino e data reconhecível;
- 8 linhas sem OM destino;
- 0 erros impeditivos na leitura;
- alertas relativos principalmente a vigências ausentes, destinos ausentes e possível duplicidade.

A planilha original apresentava valores de “dias para vencer” interpretados como datas de 1900. O sistema ignora essa coluna e calcula a diferença diretamente entre a vigência final e a data atual.
