CREATE MATERIALIZED VIEW mv_alocacoes_completas AS
SELECT
    t.ID_TURMA,
    d.NM_DISCIPLINA,
    p.NM_PROFESSOR,
    s.NM_SALA,
    s.TP_SALA,
    s.NU_CAPACIDADE,
    h.TP_DIA_SEMANA,
    h.DH_INICIO,
    h.DH_FIM,
    t.ST_TURMA
FROM RL_Alocacao a
JOIN TB_Turma t        ON a.FK_TURMA = t.ID_TURMA
JOIN TB_Disciplina d   ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
JOIN TB_Professor p    ON t.FK_PROFESSOR = p.ID_PROFESSOR
JOIN TB_Sala s         ON a.FK_SALA = s.ID_SALA
JOIN TB_Horario h      ON a.FK_HORARIO = h.ID_HORARIO;
