from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Consulta desde Hive") \
    .enableHiveSupport() \
    .getOrCreate()

# Verifica bases de datos disponibles
spark.sql("SHOW DATABASES").show()

# Cambia a la base de datos que creaste (ej: f1)
spark.sql("USE f1")

# Verifica tablas disponibles
spark.sql("SHOW TABLES").show()

# Ejecuta consulta sobre tabla Hive
df = spark.sql("SELECT * FROM drivers LIMIT 10")
df.show()

spark.stop()
