USE restaurante_olap;

LOAD DATA LOCAL INPATH '/tmp/dim_cliente.csv' INTO TABLE dim_cliente;
LOAD DATA LOCAL INPATH '/tmp/dim_restaurante.csv' INTO TABLE dim_restaurante;
LOAD DATA LOCAL INPATH '/tmp/dim_producto.csv' INTO TABLE dim_producto;
LOAD DATA LOCAL INPATH '/tmp/dim_fecha.csv' INTO TABLE dim_fecha;
LOAD DATA LOCAL INPATH '/tmp/dim_estado_pedido.csv' INTO TABLE dim_estado_pedido;
LOAD DATA LOCAL INPATH '/tmp/dim_estado_reserva.csv' INTO TABLE dim_estado_reserva;

LOAD DATA LOCAL INPATH '/tmp/fact_reserva.csv' INTO TABLE fact_reserva;
LOAD DATA LOCAL INPATH '/tmp/fact_pedido.csv' INTO TABLE fact_pedido;
