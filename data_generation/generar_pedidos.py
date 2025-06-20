# -----------------------------
# Generar fact_pedido.csv
# -----------------------------
import pandas as pd
import random

# Simulación básica del catálogo de productos para precios
productos = {i: round(random.uniform(3.0, 20.0), 2) for i in range(1, 101)}

def generar_fact_pedido(n=3000, max_cliente=200, max_rest=20, max_fecha=730):
    estados = ['pendiente', 'preparando', 'completado', 'cancelado']
    data = []
    for i in range(1, n+1):
        producto_id = random.randint(1, 100)
        cantidad = random.randint(1, 4)
        precio = productos[producto_id]
        data.append({
            "pedido_id": i,
            "cliente_id": random.randint(1, max_cliente),
            "restaurante_id": random.randint(1, max_rest),
            "producto_id": producto_id,
            "fecha_id": random.randint(1, max_fecha),
            "estado_pedido": random.choice(estados),
            "cantidad": cantidad,
            "monto_total": round(cantidad * precio, 2)
        })
    return pd.DataFrame(data)

df = generar_fact_pedido()
df.to_csv("fact_pedido.csv", index=False)
df.head()
