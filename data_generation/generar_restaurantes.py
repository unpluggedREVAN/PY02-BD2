# -----------------------------
# Generar dim_restaurante.csv
# -----------------------------
import pandas as pd
from faker import Faker
import random

fake = Faker('es_ES')

def generar_dim_restaurante(n=20):
    data = []
    for i in range(1, n+1):
        data.append({
            "restaurante_id": i,
            "nombre": fake.company(),
            "direccion": fake.address().replace("\n", ", "),
            "telefono": fake.phone_number(),
            "id_administrador": 1  # valor fijo para simplificar
        })
    return pd.DataFrame(data)

df = generar_dim_restaurante(20)
df.to_csv("dim_restaurante.csv", index=False)
df.head()
