# Medidas DAX do modelo (exemplo)

Modelo estrela: `fato_vendas` e `fato_visitas` ligadas a `dim_vendedor`, `dim_produto` e `dim_calendario` (relações 1:N, filtro em direção única).

```dax
Faturamento = SUM ( fato_vendas[valor] )

Quantidade = SUM ( fato_vendas[qtd] )

Visitas = COUNTROWS ( fato_visitas )

Médicos Visitados = DISTINCTCOUNT ( fato_visitas[medico_id] )

Faturamento por Visita = DIVIDE ( [Faturamento], [Visitas] )

Faturamento Mês Anterior =
CALCULATE ( [Faturamento], DATEADD ( dim_calendario[data], -1, MONTH ) )

Var % Mês =
DIVIDE ( [Faturamento] - [Faturamento Mês Anterior], [Faturamento Mês Anterior] )

Faturamento Acumulado Ano =
TOTALYTD ( [Faturamento], dim_calendario[data] )

% Participação Regional =
DIVIDE ( [Faturamento], CALCULATE ( [Faturamento], ALL ( dim_vendedor[regional] ) ) )

Ranking Vendedor =
RANKX ( ALL ( dim_vendedor[nome] ), [Faturamento], , DESC, DENSE )
```

**Boas práticas aplicadas:** medidas explícitas (nada de soma implícita), `DIVIDE` no lugar de `/`, tabela calendário marcada como tabela de datas, nomes em português de negócio.
