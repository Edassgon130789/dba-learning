-- =============================================
-- SEMANA 2 - Administración de PostgreSQL
-- =============================================

-- USUARIOS Y ROLES
CREATE ROLE abogados_ro;
CREATE USER laura_gomez WITH PASSWORD 'password123';
GRANT abogados_ro TO laura_gomez;
GRANT CONNECT ON DATABASE mi_db TO abogados_ro;
GRANT USAGE ON SCHEMA public TO abogados_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO abogados_ro;

-- Ver roles creados
SELECT rolname, rolsuper, rolcanlogin 
FROM pg_roles 
WHERE rolname NOT LIKE 'pg_%';

-- Revocar permisos de escritura
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM abogados_ro;

-- BACKUP Y RESTORE
-- Backup (ejecutar en PowerShell):
-- docker exec pg-local pg_dump -U admin -d mi_db -F c -f /tmp/mi_db_backup.dump
-- docker cp pg-local:/tmp/mi_db_backup.dump C:\Users\%USERNAME%\Desktop\mi_db_backup.dump

-- Restore (ejecutar en PowerShell):
-- docker cp C:\Users\%USERNAME%\Desktop\mi_db_backup.dump pg-local:/tmp/mi_db_backup.dump
-- docker exec pg-local pg_restore -U admin -d mi_db -v /tmp/mi_db_backup.dump

-- MONITOREO
-- Conexiones activas
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE datname = 'mi_db';

-- Tamaño de tablas
SELECT 
    relname AS tabla,
    pg_size_pretty(pg_total_relation_size(relid)) AS tamaño_total,
    pg_size_pretty(pg_relation_size(relid)) AS tamaño_datos,
    pg_size_pretty(pg_indexes_size(relid)) AS tamaño_indices
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Queries más lentas (requiere extensión pg_stat_statements)
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 5;
