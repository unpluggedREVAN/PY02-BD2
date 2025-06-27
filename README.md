````markdown
# Proyecto OLAP Restaurantes 

Pipeline analítico para reservas y pedidos de restaurantes.  
Procesa CSV → Spark → Hive (esquema estrella + 5 cubos) y visualiza en Superset, todo en Docker.

| Componente | Rol |
|------------|-----|
| **Hadoop HDFS** | staging de archivos |
| **Spark 3.3** | ETL y consultas |
| **Hive 2.3** | Data Warehouse |
| **Superset 2.x** | Dashboards |

## Arranque rápido

```bash
git clone https://github.com/tu-usuario/proyecto-olap.git
cd proyecto-olap/hive
docker compose up -d                       # levanta todo
docker exec -it hive-hive-server-1 \
  beeline -u jdbc:hive2://localhost:10000 \
  -f /tmp/restaurante_olap_init.sql        # crea tablas y carga CSV
open http://localhost:8088  # admin / admin123
````

## Cubos OLAP

* **mv\_ingresos\_mes\_cat** – Ventas por mes y categoría
* **mv\_reservas\_estado** – Reservas por estado
* **mv\_pedidos\_estado** – Pedidos por estado y día
* **mv\_actividad\_geo** – Pedidos por provincia/cantón
* **mv\_frecuencia\_cliente** – Frecuencia de compra por cliente

## Ejemplo Spark

```scala
spark.sql("""
  SELECT anio, mes, SUM(ingresos) AS ventas
  FROM mv_ingresos_mes_cat
  GROUP BY anio, mes
  ORDER BY anio, mes
""").show()
```

## Apagar

```bash
docker compose down -v
```

> Hecho para BD II 2025 – ITCR

```
```
