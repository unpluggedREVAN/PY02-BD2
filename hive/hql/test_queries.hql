USE restaurante_olap;

-- Validar cantidades de registros
SELECT 'Clientes', COUNT(*) FROM dim_cliente;
SELECT 'Restaurantes', COUNT(*) FROM dim_restaurante;
SELECT 'Productos', COUNT(*) FROM dim_producto;
SELECT 'Fechas', COUNT(*) FROM dim_fecha;
SELECT 'Estados Pedido', COUNT(*) FROM dim_estado_pedido;
SELECT 'Estados Reserva', COUNT(*) FROM dim_estado_reserva;
SELECT 'Reservas', COUNT(*) FROM fact_reserva;
SELECT 'Pedidos', COUNT(*) FROM fact_pedido;

-- Ver registros de ejemplo
SELECT * FROM fact_pedido LIMIT 5;
SELECT * FROM fact_reserva LIMIT 5;
