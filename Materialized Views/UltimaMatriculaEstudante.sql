CREATE MATERIALIZED VIEW mv_estudantes_ult_matricula AS
SELECT 
    e.id_estudante,
    e.nm_estudante,
    e.cd_matricula,
    e.dt_ultima_matricula,
    t.id_turma,
    d.nm_disciplina,
    p.nm_professor,
    t.tp_periodo,
    t.st_turma
FROM tb_estudante e
JOIN rl_estudante_turma et ON e.id_estudante = et.fk_estudante
JOIN tb_turma t ON et.fk_turma = t.id_turma
JOIN tb_disciplina d ON t.fk_disciplina = d.id_disciplina
JOIN tb_professor p ON t.fk_professor = p.id_professor
ORDER BY e.dt_ultima_matricula DESC NULLS LAST;
