// 1A.  Construir DataFrame base
val pedidos = spark.table("fact_pedido")
val fecha    = spark.table("dim_fecha")
val prod     = spark.table("dim_producto")

val dfCatMes = pedidos
  .join(fecha , "fecha_id")
  .join(prod  , "producto_id")
  .groupBy($"anio", $"mes", $"categoria")
  .agg(
        sum($"cantidad")      .as("uds_vendidas"),
        round(sum($"monto_total"),2).as("ingresos")
      )
  .orderBy($"anio", $"mes")

dfCatMes.cache()

// 1B.  Detectar tendencia ↑/↓ usando window
import org.apache.spark.sql.expressions.Window
val w = Window.partitionBy($"categoria").orderBy($"anio", $"mes")

val tendencia = dfCatMes
  .withColumn("ingresos_prev", lag($"ingresos",1).over(w))
  .withColumn("tendencia",
     when($"ingresos_prev".isNull, "N/A")
     .when($"ingresos" > $"ingresos_prev", "↑ Crece")
     .when($"ingresos" < $"ingresos_prev", "↓ Cae")
     .otherwise("→ Plano")
  )

tendencia.show(20, truncate = false)


// 2A. Pico en PEDIDOS
val picoPed = pedidos
  .groupBy($"hora")
  .count()
  .orderBy($"count".desc)

println("Horas pico – Pedidos")
picoPed.show(5)

// 2B. Pico en RESERVAS
val reservas = spark.table("fact_reserva")

val picoRes = reservas
  .groupBy($"hora")
  .count()
  .orderBy($"count".desc)

println("Horas pico – Reservas")
picoRes.show(5)


// 3A.  Ingresos por mes (re-usa la vista materializada del cubo)
val ingresosMes = spark.table("mv_ingresos_mes_cat")  // ya agrupa por categoría
  .groupBy($"anio", $"mes")
  .agg(sum($"ingresos").as("ingresos_total"))
  .orderBy($"anio", $"mes")

// 3B.  Calcular % crecimiento respecto al mes anterior
val wMes = Window.orderBy($"anio", $"mes")

val crecimiento = ingresosMes
  .withColumn("ingresos_prev", lag($"ingresos_total",1).over(wMes))
  .withColumn("pct_growth",
        round(($"ingresos_total" - $"ingresos_prev") / $"ingresos_prev" * 100, 2))
  .na.fill(Map("pct_growth" -> 0))   // primer mes no tiene anterior

crecimiento.show()
