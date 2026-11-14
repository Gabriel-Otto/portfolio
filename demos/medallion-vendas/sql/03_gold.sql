-- GOLD: modelo estrela pronto para o Power BI (no Fabric: modelo semântico Direct Lake).
CREATE OR REPLACE TABLE dim_vendedor AS
SELECT cod_vendedor, nome, regional FROM bronze_vendedores;

CREATE OR REPLACE TABLE dim_produto AS
SELECT cod_produto, descricao, categoria FROM bronze_produtos;

CREATE OR REPLACE TABLE dim_calendario AS
SELECT d::DATE AS data,
       year(d) AS ano, month(d) AS mes,
       strftime(d, '%Y-%m') AS ano_mes,
       isodow(d) AS dia_semana
FROM range(DATE '2026-01-01', DATE '2026-12-31' + 1, INTERVAL 1 DAY) t(d);

CREATE OR REPLACE TABLE fato_vendas AS
SELECT id_venda, data_venda AS data, cod_vendedor, cod_produto, qtd, valor
FROM silver_vendas;

CREATE OR REPLACE TABLE fato_visitas AS
SELECT data_visita AS data, cod_vendedor, medico_id FROM silver_visitas;
