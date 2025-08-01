-- DBA
CREATE ROLE dba_admin LOGIN SUPERUSER PASSWORD 'dba123';

-- Sistema (aplicação)
CREATE ROLE sistema_app LOGIN PASSWORD 'sistema123';
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO sistema_app;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO sistema_app;

-- Análise
CREATE ROLE analise_dados LOGIN PASSWORD 'analise123';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analise_dados;
GRANT SELECT ON ALL MATERIALIZED VIEWS IN SCHEMA public TO analise_dados;

-- Backup
CREATE ROLE operador_backup LOGIN PASSWORD 'backup123';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO operador_backup;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM operador_backup;
