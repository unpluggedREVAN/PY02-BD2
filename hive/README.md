# Proyecto Apache Hive + Docker – Base de Datos de Fórmula 1

Este proyecto implementa un entorno de Apache Hive con Docker para analizar datos históricos de Fórmula 1 mediante consultas HiveQL.

## Tabla de Contenidos
- [Requisitos](#-requisitos-previos)
- [Configuración](#-levantar-el-entorno)
- [Carga de datos](#-cargar-archivos-csv-al-contenedor)
- [Consultas](#-consultas-hiveql-representativas)
- [Estructura](#-estructura-del-proyecto)

## Requisitos Previos
- Docker Engine v20+
- Docker Compose v2+
- 4GB RAM disponibles
- Datos en CSV: constructors, drivers, races, results

## Levantar el Entorno
```bash
docker compose up -d
```

Verificar contenedores:
```bash
docker ps
```

## Conexión a Hive
Acceder al CLI de Hive:
```bash
docker exec -it docker-hive-hive-server-1 bash
beeline -u jdbc:hive2://localhost:10000
```

## Modelo de Datos
```sql
CREATE DATABASE f1;
USE f1;

-- Esquema para constructores
CREATE TABLE constructors (
  constructorId INT,
  constructorRef STRING,
  name STRING,
  nationality STRING,
  url STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Similar para drivers, races, results...
```

## Carga de Datos
Copiar archivos al contenedor:
```bash
docker cp datos/constructors.csv docker-hive-hive-server-1:/tmp/
```

Cargar en Hive:
```sql
LOAD DATA LOCAL INPATH '/tmp/constructors.csv' INTO TABLE constructors;
```

## Consultas Destacadas

### Top 10 pilotos históricos
```sql
SELECT d.forename, d.surname, COUNT(*) as wins 
FROM results r JOIN drivers d ON r.driverId = d.driverId 
WHERE r.position = 1 
GROUP BY d.forename, d.surname 
ORDER BY wins DESC 
LIMIT 10;
```

### Evolución de equipos
```sql
SELECT c.name, r.year, AVG(r.points) as avg_points
FROM results r JOIN constructors c ON r.constructorId = c.constructorId
              JOIN races rc ON r.raceId = rc.raceId
GROUP BY c.name, r.year
ORDER BY c.name, r.year;
```

