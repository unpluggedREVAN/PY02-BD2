-- Asumimos que ya estás en restaurante_olap
USE restaurante_olap;

-- ================================
-- TABLAS DE DIMENSIONES
-- ================================

-- Clientes
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

-- Restaurantes
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

-- Productos
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

-- Fechas
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

-- Estado de pedido
CREATE EXTERNAL TABLE IF NOT EXISTS dim_estado_pedido (
  estado_pedido STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Estado de reserva
CREATE EXTERNAL TABLE IF NOT EXISTS dim_estado_reserva (
  estado_reserva STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- ================================
-- TABLAS DE HECHOS
-- ================================

CREATE TABLE IF NOT EXISTS fact_reserva (
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

CREATE TABLE IF NOT EXISTS fact_pedido (
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
