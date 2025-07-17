CREATE OR REPLACE PROCEDURE sp_refresh_views_operacionais()
LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_salas_ocupadas_hoje;
    REFRESH MATERIALIZED VIEW mv_avaliacoes_proximos_7_dias;
    REFRESH MATERIALIZED VIEW mv_disciplinas_laboratorios_sem_computador;
    REFRESH MATERIALIZED VIEW mv_horarios_mais_utilizados;
    REFRESH MATERIALIZED VIEW mv_media_estudantes_por_turma;
    REFRESH MATERIALIZED VIEW mv_ranking_turmas_avaliacoes;
END;
$$;
