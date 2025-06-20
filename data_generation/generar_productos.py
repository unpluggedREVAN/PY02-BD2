# -----------------------------
# Generar dim_producto.csv
# -----------------------------
import pandas as pd
from faker import Faker
import random

fake = Faker('es_ES')

categorias = ['Pizzas', 'Postres', 'Entradas', 'Ensaladas', 'Bebidas', 'Hamburguesas']

def generar_dim_producto(n=100):
    data = []
    for i in range(1, n+1):
        data.append({
            "producto_id": i,
            "nombre": fake.word().capitalize() + " especial",
            "categoria": random.choice(categorias),
            "precio_unitario": round(random.uniform(3.5, 15.0), 2)
        })
    return pd.DataFrame(data)

df = generar_dim_producto(100)
df.to_csv("dim_producto.csv", index=False)
df.head()
