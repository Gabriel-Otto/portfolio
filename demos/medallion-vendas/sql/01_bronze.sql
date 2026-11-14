-- BRONZE: dados brutos como chegaram da fonte (sem tratamento), só com metadados de carga.
-- No Microsoft Fabric isso seria um notebook de ingestão gravando tabelas Delta no Lakehouse.
CREATE OR REPLACE TABLE bronze_vendas AS
SELECT *, 'vendas_raw.csv' AS _fonte, current_timestamp AS _carregado_em
FROM read_csv('data/vendas_raw.csv', all_varchar = true);

CREATE OR REPLACE TABLE bronze_visitas AS
SELECT *, 'visitas_raw.csv' AS _fonte, current_timestamp AS _carregado_em
FROM read_csv('data/visitas_raw.csv', all_varchar = true);

CREATE OR REPLACE TABLE bronze_vendedores AS SELECT * FROM read_csv('data/vendedores.csv', all_varchar = true);
CREATE OR REPLACE TABLE bronze_produtos   AS SELECT * FROM read_csv('data/produtos.csv',   all_varchar = true);
