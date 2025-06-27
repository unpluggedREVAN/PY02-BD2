CREATE MATERIALIZED VIEW mv_ingresos_mes_cat STORED AS ORC AS SELECT d.anio , d.mes , p.categoria , SUM(f.monto_total) AS ingresos FROM fact_pedido f JOIN dim_fecha d ON f.fecha_id = d.fecha_id JOIN dim_producto p ON f.producto_id = p.producto_id GROUP BY d.anio , d.mes , p.categoria;

CREATE MATERIALIZED VIEW mv_pedidos_estado_mes STORED AS ORC AS SELECT d.anio , d.mes , f.estado_pedido , COUNT(*) AS total_pedidos FROM fact_pedido f JOIN dim_fecha d ON f.fecha_id = d.fecha_id GROUP BY d.anio , d.mes , f.estado_pedido;

CREATE MATERIALIZED VIEW mv_reservas_estado_mes STORED AS ORC AS SELECT d.anio , d.mes , r.estado_reserva , COUNT(*) AS total_reservas FROM fact_reserva r JOIN dim_fecha d ON r.fecha_id = d.fecha_id GROUP BY d.anio , d.mes , r.estado_reserva;

CREATE MATERIALIZED VIEW mv_ingresos_rest_mes STORED AS ORC AS SELECT d.anio , d.mes , r.restaurante_id , r.nombre AS restaurante , SUM(f.monto_total) AS ingresos FROM fact_pedido f JOIN dim_fecha d ON f.fecha_id = d.fecha_id JOIN dim_restaurante r ON f.restaurante_id = r.restaurante_id GROUP BY d.anio , d.mes , r.restaurante_id , r.nombre;

sql CREATE MATERIALIZED VIEW mv_top_productos STORED AS ORC AS SELECT p.producto_id , p.nombre , p.categoria , SUM(f.cantidad) AS uds_vendidas FROM fact_pedido f JOIN dim_producto p ON f.producto_id = p.producto_id GROUP BY p.producto_id , p.nombre , p.categoria;

