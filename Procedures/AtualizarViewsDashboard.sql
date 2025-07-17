CREATE OR REPLACE PROCEDURE sp_refresh_todas_views_estrategicas()
LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_media_notas_por_disciplina;
    REFRESH MATERIALIZED VIEW mv_media_avaliacoes_por_periodo;
    REFRESH MATERIALIZED VIEW mv_professor_turmas_e_notas;
    REFRESH MATERIALIZED VIEW mv_capacidade_por_tipo_sala_usada;
END;
$$;
