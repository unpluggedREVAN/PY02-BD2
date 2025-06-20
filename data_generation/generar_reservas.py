# -----------------------------
# Generar fact_reserva.csv
# -----------------------------
import pandas as pd
import random

def generar_fact_reserva(n=1000, max_cliente=200, max_rest=20, max_fecha=730):
    estados = ['pendiente', 'confirmada', 'cancelada']
    data = []
    for i in range(1, n+1):
        data.append({
            "reserva_id": i,
            "cliente_id": random.randint(1, max_cliente),
            "restaurante_id": random.randint(1, max_rest),
            "fecha_id": random.randint(1, max_fecha),
            "numero_personas": random.randint(1, 8),
            "estado_reserva": random.choice(estados)
        })
    return pd.DataFrame(data)

df = generar_fact_reserva()
df.to_csv("fact_reserva.csv", index=False)
df.head()
