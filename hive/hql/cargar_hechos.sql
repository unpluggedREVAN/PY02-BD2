-- Crear tabla fact_pedido
DROP TABLE IF EXISTS fact_pedido;

CREATE TABLE fact_pedido (
  pedido_id BIGINT,
  cliente_id BIGINT,
  restaurante_id BIGINT,
  producto_id BIGINT,
  fecha_id INT,
  estado_pedido STRING,
  cantidad INT,
  monto_total DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Crear tabla fact_reserva
DROP TABLE IF EXISTS fact_reserva;

CREATE TABLE fact_reserva (
  reserva_id BIGINT,
  cliente_id BIGINT,
  restaurante_id BIGINT,
  fecha_id INT,
  numero_personas INT,
  estado_reserva STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Cargar datos
LOAD DATA LOCAL INPATH '/tmp/fact_pedido.csv' OVERWRITE INTO TABLE fact_pedido;
LOAD DATA LOCAL INPATH '/tmp/fact_reserva.csv' OVERWRITE INTO TABLE fact_reserva;
