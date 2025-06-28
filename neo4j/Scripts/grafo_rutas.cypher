// CARGA CSV CARTAGO
CALL apoc.import.graphml(
  'calles.graphml',
  {readLabels:true, storeNodeProperties:true, storeEdgeProperties:true}
);



//CARGA ESTRUCTURA
LOAD CSV WITH HEADERS FROM 'file:///clientes.csv' AS row
MERGE (c:Cliente {cliente_id: toInteger(row.cliente_id)})
  SET c.nombre     = row.nombre_completo,
      c.email      = row.email,
      c.latitud    = toFloat(row.latitud),
      c.longitud   = toFloat(row.longitud);

LOAD CSV WITH HEADERS FROM 'file:///restaurantes.csv' AS row
MERGE (r:Restaurante {restaurante_id: toInteger(row.restaurante_id)})
  SET r.nombre     = row.nombre_restaurante,
      r.ciudad     = row.ciudad,
      r.latitud    = toFloat(row.latitud),
      r.longitud   = toFloat(row.longitud);

LOAD CSV WITH HEADERS FROM 'file:///productos.csv' AS row
MERGE (p:Producto {producto_id: toInteger(row.producto_id)})
  SET p.nombre     = row.nombre_plato,
      p.categoria  = row.categoria,
      p.precio     = toFloat(row.precio)
WITH p, row
MATCH (r:Restaurante {restaurante_id: toInteger(row.restaurante_id)})
MERGE (r)-[:OFRECE]->(p);

LOAD CSV WITH HEADERS FROM 'file:///ordenes.csv' AS row
MERGE (o:Pedido {pedido_id: toInteger(row.pedido_id)})
  SET o.fecha = date(row.fecha)
WITH o, row
MATCH (c:Cliente     {cliente_id: toInteger(row.cliente_id)}),
      (p:Producto    {producto_id: toInteger(row.producto_id)}),
      (r:Restaurante {restaurante_id: toInteger(row.restaurante_id)})
MERGE (c)-[:ORDENA]->(o)
MERGE (o)-[:INCLUYE]->(p)
MERGE (o)-[:EN_RESTAURANTE]->(r);

MATCH (c:Cliente)
MERGE (u:Ubicacion {id: 'C' + toString(c.cliente_id)})
  SET u.coord = point({latitude: c.latitud, longitude: c.longitud})
MERGE (c)-[:UBICADO_EN]->(u);

MATCH (r:Restaurante)
MERGE (u:Ubicacion {id: 'R' + toString(r.restaurante_id)})
  SET u.coord = point({latitude: r.latitud, longitude: r.longitud})
MERGE (r)-[:UBICADO_EN]->(u);


//CONEXIÓN REST-USER <-> STREET
CREATE INDEX street_coord_index IF NOT EXISTS
FOR (n:StreetNode) ON (n.coord);

// Para cada Restaurante
MATCH (r:Restaurante)
WITH r, point({latitude:r.latitud, longitude:r.longitud}) AS pt
CALL apoc.nearest.neighbor.stream(
  'StreetNode','coord',{latitude:pt.latitude,longitude:pt.longitude},1
) YIELD node AS street, distance
MERGE (r)-[:ON_ROAD]->(street);

// Para cada Cliente
MATCH (c:Cliente)
WITH c, point({latitude:c.latitud, longitude:c.longitud}) AS pt
CALL apoc.nearest.neighbor.stream(
  'StreetNode','coord',{latitude:pt.latitude,longitude:pt.longitude},1
) YIELD node AS street, distance
MERGE (c)-[:ON_ROAD]->(street);


//PATRÓN CO-COMPRA;RECOMENDACIONES
MATCH 
  (c:Cliente)-[:ORDENA]->(:Pedido)-[:INCLUYE]->(p1:Producto),
  (c)-[:ORDENA]->(:Pedido)-[:INCLUYE]->(p2:Producto)
WHERE p1 <> p2
WITH p1, p2, count(DISTINCT c) AS veces
RETURN 
  p1.nombre AS ProductoA, 
  p2.nombre AS ProductoB, 
  veces
ORDER BY veces DESC
LIMIT 5;

// TOP 5 MÁS COMPRADOS JUNTOS
MATCH (c:Cliente)-[:ORDENA]->(:Pedido)-[:INCLUYE]->(p1:Producto),
      (c)-[:ORDENA]->(:Pedido)-[:INCLUYE]->(p2:Producto)
WHERE id(p1) < id(p2)      // solo pares con p1 “menor” que p2
WITH p1, p2, count(DISTINCT c) AS veces
RETURN
  p1.nombre     AS ProductoA,
  p2.nombre     AS ProductoB,
  veces
ORDER BY veces DESC
LIMIT 5;