# -----------------------------
# Generar dim_cliente.csv
# -----------------------------
import pandas as pd
from faker import Faker
import random

fake = Faker('es_ES')

def generar_dim_cliente(n=200):
    data = []
    for i in range(1, n+1):
        data.append({
            "cliente_id": i,
            "nombre": fake.name(),
            "correo": fake.email(),
            "tipo_usuario": "cliente"
        })
    return pd.DataFrame(data)

df = generar_dim_cliente(200)
df.to_csv("dim_cliente.csv", index=False)
df.head()
