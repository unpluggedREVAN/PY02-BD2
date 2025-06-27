
-- Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS restaurante_olap;
USE restaurante_olap;

-- Tablas de Dimensiones
CREATE EXTERNAL TABLE IF NOT EXISTS dim_cliente (
  cliente_id BIGINT,
  nombre STRING,
  correo STRING,
  tipo_usuario STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS dim_restaurante (
  restaurante_id BIGINT,
  nombre STRING,
  direccion STRING,
  telefono STRING,
  id_administrador BIGINT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS dim_producto (
  producto_id BIGINT,
  nombre STRING,
  categoria STRING,
  precio_unitario DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS dim_fecha (
  fecha_id INT,
  fecha STRING,
  anio INT,
  mes STRING,
  dia INT,
  semana INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS dim_estado_pedido (
  estado_pedido STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS dim_estado_reserva (
  estado_reserva STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Tablas de Hechos
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

-- Cargar datos desde archivos CSV
LOAD DATA LOCAL INPATH '/tmp/dim_cliente.csv' INTO TABLE dim_cliente;
LOAD DATA LOCAL INPATH '/tmp/dim_restaurante.csv' INTO TABLE dim_restaurante;
LOAD DATA LOCAL INPATH '/tmp/dim_producto.csv' INTO TABLE dim_producto;
LOAD DATA LOCAL INPATH '/tmp/dim_fecha.csv' INTO TABLE dim_fecha;

LOAD DATA LOCAL INPATH '/tmp/fact_reserva.csv' OVERWRITE INTO TABLE fact_reserva;
LOAD DATA LOCAL INPATH '/tmp/fact_pedido.csv' OVERWRITE INTO TABLE fact_pedido;

-- Insertar valores manuales
INSERT INTO TABLE dim_estado_pedido VALUES ('pendiente');
INSERT INTO TABLE dim_estado_pedido VALUES ('cancelado');
INSERT INTO TABLE dim_estado_pedido VALUES ('preparando');

INSERT INTO TABLE dim_estado_reserva VALUES ('confirmada');
INSERT INTO TABLE dim_estado_reserva VALUES ('pendiente');
INSERT INTO TABLE dim_estado_reserva VALUES ('cancelada');
