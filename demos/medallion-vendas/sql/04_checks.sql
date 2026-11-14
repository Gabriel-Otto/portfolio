-- Checagens de qualidade (no Fabric: célula final do notebook / alerta no pipeline)
SELECT 'bronze_vendas'             AS tabela, COUNT(*) AS linhas FROM bronze_vendas
UNION ALL SELECT 'silver_vendas',            COUNT(*) FROM silver_vendas
UNION ALL SELECT 'silver_vendas_rejeitadas', COUNT(*) FROM silver_vendas_rejeitadas
UNION ALL SELECT 'datas_nulas_silver',       COUNT(*) FROM silver_vendas WHERE data_venda IS NULL
UNION ALL SELECT 'vendedor_sem_cadastro',    COUNT(*) FROM fato_vendas f
          LEFT JOIN dim_vendedor v USING (cod_vendedor) WHERE v.cod_vendedor IS NULL;

-- Exemplo de pergunta de negócio: faturamento e visitas por regional/mês
SELECT v.regional, c.ano_mes,
       ROUND(SUM(f.valor), 2)                     AS faturamento,
       (SELECT COUNT(*) FROM fato_visitas fv
          JOIN dim_vendedor v2 USING (cod_vendedor)
         WHERE v2.regional = v.regional
           AND strftime(fv.data, '%Y-%m') = c.ano_mes) AS visitas
FROM fato_vendas f
JOIN dim_vendedor v USING (cod_vendedor)
JOIN dim_calendario c ON c.data = f.data
GROUP BY ALL ORDER BY v.regional, c.ano_mes;
