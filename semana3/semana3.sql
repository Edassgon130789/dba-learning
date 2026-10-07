-- =============================================
-- SEMANA 3 - Performance Tuning
-- =============================================

-- EXPLAIN ANALYZE - leer el plan de ejecución
EXPLAIN ANALYZE
SELECT cl.nombre, COUNT(c.id) AS total_casos
FROM clientes cl
LEFT JOIN casos c ON cl.id = c.cliente_id
GROUP BY cl.nombre;

-- ÍNDICES - acelerar queries
CREATE INDEX idx_casos_cliente_id ON casos(cliente_id);
CREATE INDEX idx_casos_abogado_id ON casos(abogado_id);
CREATE INDEX idx_casos_estado ON casos(estado);

-- Ver todos los índices existentes
SELECT indexname, tablename, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename;

-- CUÁNDO crear índices:
-- SÍ: claves foráneas, columnas en WHERE frecuente, columnas en JOIN
-- NO: tablas pequeñas, columnas con pocos valores distintos, columnas que cambian mucho
