"""Gera os CSVs sintéticos da demo (semente fixa = sempre os mesmos dados).

Os problemas de qualidade são inseridos DE PROPÓSITO para a camada silver tratar:
datas em dois formatos, códigos em minúsculas, quantidades nulas, vírgula decimal e uma duplicata.
"""
import csv
import datetime
import pathlib
import random

random.seed(42)
DATA = pathlib.Path("data")
DATA.mkdir(exist_ok=True)

VENDEDORES = [("R01", "Ana", "Sudeste"), ("R02", "Bruno", "Sudeste"), ("R03", "Carla", "Sul"),
              ("R04", "Diego", "Nordeste"), ("R05", "Elisa", "Centro-Oeste")]
PRODUTOS = [("P01", "Analgésico 500mg", "Dor"), ("P02", "Antialérgico 10mg", "Alergia"),
            ("P03", "Antiácido 20mg", "Gástrico"), ("P04", "Vitamina D 2000UI", "Suplemento")]
PRECOS = {"P01": 12.9, "P02": 18.5, "P03": 15.2, "P04": 32.0}
INICIO = datetime.date(2026, 1, 1)


def escrever(nome, cabecalho, linhas):
    with open(DATA / nome, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(cabecalho)
        w.writerows(linhas)


escrever("vendedores.csv", ["cod_vendedor", "nome", "regional"], VENDEDORES)
escrever("produtos.csv", ["cod_produto", "descricao", "categoria"], PRODUTOS)

vendas, i = [], 0
for dia in range(60):
    for _ in range(random.randint(3, 7)):
        i += 1
        vend = random.choice(VENDEDORES)[0]
        prod = random.choice(list(PRECOS))
        qtd = random.randint(1, 40)
        d = INICIO + datetime.timedelta(days=dia)
        data = d.strftime("%d/%m/%Y") if i % 7 else d.isoformat()   # formatos mistos
        if i % 53 == 0:
            qtd = ""                                                  # nulo
        vend = vend.lower() if i % 11 == 0 else vend                  # minúsculas
        vendas.append([i, data, vend, prod, qtd, str(PRECOS[prod]).replace(".", ",")])
vendas.append([5, INICIO.strftime("%d/%m/%Y"), "R01", "P01", 3, "12,9"])  # duplicata
escrever("vendas_raw.csv", ["id", "data", "cod_vendedor", "cod_produto", "qtd", "preco_unit"], vendas)

visitas = []
for dia in range(60):
    for vend in VENDEDORES:
        for _ in range(random.randint(1, 3)):
            visitas.append([(INICIO + datetime.timedelta(days=dia)).isoformat(), vend[0],
                            f"M{random.randint(1, 40):03d}"])
escrever("visitas_raw.csv", ["data", "cod_vendedor", "medico_id"], visitas)

print(f"Dados gerados em {DATA}/: {len(vendas)} vendas, {len(visitas)} visitas")
