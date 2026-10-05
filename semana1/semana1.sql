-- =============================================
-- SEMANA 1 - Fundamentos de bases de datos
-- Proyecto: Sistema de gestión legal
-- =============================================

-- MODELO DE DATOS
CREATE TABLE abogados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_incorporacion DATE DEFAULT CURRENT_DATE
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    tipo VARCHAR(20) CHECK (tipo IN ('empresa', 'particular')),
    fecha_alta DATE DEFAULT CURRENT_DATE
);

CREATE TABLE casos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('abierto', 'cerrado', 'en revisión')),
    cliente_id INT REFERENCES clientes(id),
    abogado_id INT REFERENCES abogados(id),
    fecha_apertura DATE DEFAULT CURRENT_DATE,
    fecha_cierre DATE
);

CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    caso_id INT REFERENCES casos(id),
    importe NUMERIC(10,2) NOT NULL,
    pagada BOOLEAN DEFAULT FALSE,
    fecha_emision DATE DEFAULT CURRENT_DATE
);

-- =============================================
-- QUERIES DE NEGOCIO
-- =============================================

-- Q1: Casos por estado
SELECT estado, COUNT(*) AS total
FROM casos
GROUP BY estado
ORDER BY total DESC;

-- Q2: Facturas pendientes por caso
SELECT c.titulo, SUM(f.importe) AS total_pendiente
FROM casos c
JOIN facturas f ON c.id = f.caso_id
WHERE f.pagada = FALSE
GROUP BY c.titulo
ORDER BY total_pendiente DESC;

-- Q3: Abogado más rentable
SELECT a.nombre, SUM(f.importe) AS total_cobrado
FROM abogados a
JOIN casos c ON a.id = c.abogado_id
JOIN facturas f ON c.id = f.caso_id
WHERE f.pagada = TRUE
GROUP BY a.nombre
ORDER BY total_cobrado DESC
LIMIT 1;

-- Q4: Clientes con casos abiertos sin abogado
SELECT c.nombre
FROM clientes c
JOIN casos ca ON c.id = ca.cliente_id
WHERE ca.estado = 'abierto' AND ca.abogado_id IS NULL;

-- Q5: Días promedio para cerrar casos por abogado
SELECT a.nombre, AVG(ca.fecha_cierre - ca.fecha_apertura) AS dias_promedio
FROM abogados a
JOIN casos ca ON a.id = ca.abogado_id
WHERE ca.fecha_cierre IS NOT NULL
GROUP BY a.nombre
ORDER BY dias_promedio;
