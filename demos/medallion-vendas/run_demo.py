"""Executa o pipeline bronze -> silver -> gold localmente com DuckDB.

Uso:
    pip install duckdb pandas
    python run_demo.py
"""
import pathlib
import subprocess
import sys

import duckdb

if not pathlib.Path("data/vendas_raw.csv").exists():
    subprocess.run([sys.executable, "gerar_dados.py"], check=True)

con = duckdb.connect("demo.duckdb")

for script in sorted(pathlib.Path("sql").glob("*.sql")):
    print(f"\n>> {script.name}")
    for stmt in script.read_text(encoding="utf-8").split(";"):
        # remove linhas de comentário para decidir se há SQL de fato
        code = "\n".join(l for l in stmt.splitlines() if not l.strip().startswith("--")).strip()
        if not code:
            continue
        result = con.execute(code)
        if code.upper().startswith("SELECT"):
            print(result.df().to_string(index=False))

print("\nPronto: banco 'demo.duckdb' com as camadas bronze, silver e gold.")
