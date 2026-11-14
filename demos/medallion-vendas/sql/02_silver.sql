-- SILVER: dados limpos e padronizados.
-- Problemas tratados (existem de propósito nos CSVs):
--   1) datas em dois formatos (dd/mm/aaaa e aaaa-mm-dd)
--   2) códigos de vendedor em minúsculas
--   3) quantidade nula
--   4) preço com vírgula decimal
--   5) linha duplicada (mesmo id)
CREATE OR REPLACE TABLE silver_vendas AS
WITH tipado AS (
    SELECT
        CAST(id AS INTEGER)                                         AS id_venda,
        COALESCE(TRY_STRPTIME(data, '%d/%m/%Y'),
                 TRY_STRPTIME(data, '%Y-%m-%d'))::DATE              AS data_venda,
        UPPER(TRIM(cod_vendedor))                                   AS cod_vendedor,
        UPPER(TRIM(cod_produto))                                    AS cod_produto,
        TRY_CAST(qtd AS INTEGER)                                    AS qtd,
        CAST(REPLACE(preco_unit, ',', '.') AS DECIMAL(10,2))        AS preco_unit,
        _carregado_em
    FROM bronze_vendas
),
dedup AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_venda ORDER BY _carregado_em) AS rn
    FROM tipado
)
SELECT id_venda, data_venda, cod_vendedor, cod_produto, qtd, preco_unit,
       qtd * preco_unit AS valor
FROM dedup
WHERE rn = 1 AND qtd IS NOT NULL;   -- registros sem quantidade vão para auditoria (abaixo)

CREATE OR REPLACE TABLE silver_vendas_rejeitadas AS
SELECT * FROM bronze_vendas WHERE TRY_CAST(qtd AS INTEGER) IS NULL;

CREATE OR REPLACE TABLE silver_visitas AS
SELECT DISTINCT CAST(data AS DATE) AS data_visita, UPPER(cod_vendedor) AS cod_vendedor, medico_id
FROM bronze_visitas;
