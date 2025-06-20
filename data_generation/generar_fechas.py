# -----------------------------
# Generar dim_fecha.csv
# -----------------------------
import pandas as pd

def generar_dim_fecha(inicio="2024-01-01", fin="2025-12-31"):
    fechas = pd.date_range(start=inicio, end=fin, freq='D')
    data = []
    for i, fecha in enumerate(fechas, start=1):
        data.append({
            "fecha_id": i,
            "fecha": fecha.strftime("%Y-%m-%d"),
            "anio": fecha.year,
            "mes": fecha.strftime("%B"),
            "dia": fecha.day,
            "semana": fecha.isocalendar().week
        })
    return pd.DataFrame(data)

df = generar_dim_fecha()
df.to_csv("dim_fecha.csv", index=False)
df.head()
