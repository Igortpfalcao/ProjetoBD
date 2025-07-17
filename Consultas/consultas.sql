--Consultas Intermediárias

--Requisito: Gerenciar disciplinas, horários e matrículas
--Objetivo: Listar cada turma com a disciplina, nome do professor, número de estudantes matriculados e o horário da turma.
SELECT 
    t.ID_TURMA,
    d.NM_DISCIPLINA,
    p.NM_PROFESSOR,
    COUNT(et.FK_ESTUDANTE) AS QTDE_ESTUDANTES,
    h.TP_DIA_SEMANA,
    h.DH_INICIO,
    h.DH_FIM
FROM TB_Turma t
JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
JOIN TB_Professor p ON t.FK_PROFESSOR = p.ID_PROFESSOR
JOIN RL_Estudante_Turma et ON t.ID_TURMA = et.FK_TURMA
JOIN RL_Alocacao a ON t.ID_TURMA = a.FK_TURMA
JOIN TB_Horario h ON a.FK_HORARIO = h.ID_HORARIO
GROUP BY t.ID_TURMA, d.NM_DISCIPLINA, p.NM_PROFESSOR, h.TP_DIA_SEMANA, h.DH_INICIO, h.DH_FIM
ORDER BY t.ID_TURMA;

---Consulta Intermediária 2

--Requisito: Controlar disponibilidade de professores
--Objetivo: Listar todos os professores disponíveis junto com as disciplinas que eles ministram e quantas turmas cada um está lecionando.
SELECT
    p.ID_PROFESSOR,
    p.NM_PROFESSOR,
    p.ST_DISPONIBILIDADE,
    d.NM_DISCIPLINA,
    COUNT(t.ID_TURMA) AS QTDE_TURMAS
FROM TB_Professor p
JOIN TB_Turma t ON p.ID_PROFESSOR = t.FK_PROFESSOR
JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
WHERE p.ST_DISPONIBILIDADE = TRUE
GROUP BY p.ID_PROFESSOR, p.NM_PROFESSOR, p.ST_DISPONIBILIDADE, d.NM_DISCIPLINA
ORDER BY p.NM_PROFESSOR;

--Requisito: Gerenciar equipamentos disponíveis em cada sala
--Objetivo: Listar todas as salas, seus tipos, capacidade e os equipamentos disponíveis em cada uma (quantidade total de equipamentos por tipo).
SELECT
    s.ID_SALA,
    s.NM_SALA,
    s.TP_SALA,
    s.NU_CAPACIDADE,
    e.TP_EQUIPAMENTO,
    COUNT(e.ID_EQUIPAMENTO) AS QTDE_EQUIPAMENTOS
FROM TB_Sala s
JOIN RL_Sala_Equipamento se ON s.ID_SALA = se.FK_SALA
JOIN TB_Equipamento e ON se.FK_EQUIPAMENTO = e.ID_EQUIPAMENTO
GROUP BY s.ID_SALA, s.NM_SALA, s.TP_SALA, s.NU_CAPACIDADE, e.TP_EQUIPAMENTO
ORDER BY s.NM_SALA, e.TP_EQUIPAMENTO;

--Requisito: Gerenciar disciplinas, horários e matrículas
--Objetivo: Para cada estudante, mostrar o nome, matrícula, quantas disciplinas está matriculado, e os dias da semana em que tem aulas.

SELECT
    es.NM_ESTUDANTE,
    es.CD_MATRICULA,
    COUNT(DISTINCT t.FK_DISCIPLINA) AS QTDE_DISCIPLINAS,
    STRING_AGG(DISTINCT h.TP_DIA_SEMANA, ', ') AS DIAS_DA_SEMANA
FROM TB_Estudante es
JOIN RL_Estudante_Turma et ON es.ID_ESTUDANTE = et.FK_ESTUDANTE
JOIN TB_Turma t ON et.FK_TURMA = t.ID_TURMA
JOIN RL_Alocacao a ON t.ID_TURMA = a.FK_TURMA
JOIN TB_Horario h ON a.FK_HORARIO = h.ID_HORARIO
GROUP BY es.ID_ESTUDANTE, es.NM_ESTUDANTE, es.CD_MATRICULA
ORDER BY es.NM_ESTUDANTE;

--Requisito: Gerar relatórios de ocupação
--Objetivo: Listar para cada sala o total de turmas alocadas por dia da semana, mostrando também a capacidade da sala.
SELECT
    s.NM_SALA,
    h.TP_DIA_SEMANA,
    s.NU_CAPACIDADE,
    COUNT(a.FK_TURMA) AS QTDE_TURMAS
FROM TB_Sala s
JOIN RL_Alocacao a ON s.ID_SALA = a.FK_SALA
JOIN TB_Horario h ON a.FK_HORARIO = h.ID_HORARIO
GROUP BY s.NM_SALA, h.TP_DIA_SEMANA, s.NU_CAPACIDADE
ORDER BY s.NM_SALA, h.TP_DIA_SEMANA;

--Requisito: Evitar conflitos de horário e superlotação
--Objetivo: Listar turmas que têm mais estudantes matriculados do que a capacidade da sala alocada, junto com o horário e a sala.
SELECT
    t.ID_TURMA,
    d.NM_DISCIPLINA,
    s.NM_SALA,
    s.NU_CAPACIDADE,
    COUNT(et.FK_ESTUDANTE) AS QTDE_ESTUDANTES,
    h.TP_DIA_SEMANA,
    h.DH_INICIO,
    h.DH_FIM
FROM TB_Turma t
JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
JOIN RL_Estudante_Turma et ON t.ID_TURMA = et.FK_TURMA
JOIN RL_Alocacao a ON t.ID_TURMA = a.FK_TURMA
JOIN TB_Sala s ON a.FK_SALA = s.ID_SALA
JOIN TB_Horario h ON a.FK_HORARIO = h.ID_HORARIO
GROUP BY t.ID_TURMA, d.NM_DISCIPLINA, s.NM_SALA, s.NU_CAPACIDADE, h.TP_DIA_SEMANA, h.DH_INICIO, h.DH_FIM
HAVING COUNT(et.FK_ESTUDANTE) > s.NU_CAPACIDADE
ORDER BY QTDE_ESTUDANTES DESC;


--Requisito: Gerenciar equipamentos disponíveis em cada sala
--Objetivo: Listar cada tipo de equipamento e o número total de salas onde ele está disponível.
SELECT
    e.TP_EQUIPAMENTO,
    COUNT(DISTINCT se.FK_SALA) AS QTDE_SALAS
FROM TB_Equipamento e
JOIN RL_Sala_Equipamento se ON e.ID_EQUIPAMENTO = se.FK_EQUIPAMENTO
GROUP BY e.TP_EQUIPAMENTO
ORDER BY QTDE_SALAS DESC;

--Requisito: Controlar disponibilidade de professores
--Objetivo: Listar professores, quantas turmas eles têm por período e se estão disponíveis.
SELECT
    p.NM_PROFESSOR,
    t.TP_PERIODO,
    p.ST_DISPONIBILIDADE,
    COUNT(t.ID_TURMA) AS QTDE_TURMAS
FROM TB_Professor p
LEFT JOIN TB_Turma t ON p.ID_PROFESSOR = t.FK_PROFESSOR
GROUP BY p.NM_PROFESSOR, t.TP_PERIODO, p.ST_DISPONIBILIDADE
ORDER BY p.NM_PROFESSOR, t.TP_PERIODO;


--Requisito: Controlar disponibilidade de professores
--Objetivo: Listar professores, a quantidade total de avaliações aplicadas por turma que eles ministram, considerando apenas os professores disponíveis.
SELECT
    p.NM_PROFESSOR,
    t.ID_TURMA,
    COUNT(a.ID_AVALIACAO) AS QTDE_AVALIACOES
FROM TB_Professor p
JOIN TB_Turma t ON p.ID_PROFESSOR = t.FK_PROFESSOR
LEFT JOIN TB_Avaliacao a ON t.ID_TURMA = a.FK_TURMA
WHERE p.ST_DISPONIBILIDADE = TRUE
GROUP BY p.NM_PROFESSOR, t.ID_TURMA
ORDER BY p.NM_PROFESSOR, t.ID_TURMA;


--Requisito: Gerar relatórios de ocupação
--Objetivo: Mostrar para cada professor o total de estudantes matriculados nas turmas que ele ministra.
SELECT
    p.NM_PROFESSOR,
    COUNT(DISTINCT et.FK_ESTUDANTE) AS QTDE_ESTUDANTES
FROM TB_Professor p
JOIN TB_Turma t ON p.ID_PROFESSOR = t.FK_PROFESSOR
JOIN RL_Estudante_Turma et ON t.ID_TURMA = et.FK_TURMA
GROUP BY p.NM_PROFESSOR
ORDER BY QTDE_ESTUDANTES DESC;

--Requisito: Evitar conflitos de horário e superlotação
--Objetivo: Listar os horários em que uma mesma sala está alocada para mais de uma turma.
SELECT
    a.FK_SALA,
    s.NM_SALA,
    h.TP_DIA_SEMANA,
    h.DH_INICIO,
    h.DH_FIM,
    COUNT(a.FK_TURMA) AS QTDE_TURMAS
FROM RL_Alocacao a
JOIN TB_Sala s ON a.FK_SALA = s.ID_SALA
JOIN TB_Horario h ON a.FK_HORARIO = h.ID_HORARIO
GROUP BY a.FK_SALA, s.NM_SALA, h.TP_DIA_SEMANA, h.DH_INICIO, h.DH_FIM
HAVING COUNT(a.FK_TURMA) > 1
ORDER BY s.NM_SALA, h.TP_DIA_SEMANA, h.DH_INICIO;


--AVANÇADAS:

--Requisito: Gerenciar disciplinas, horários e matrículas
--Objetivo: Listar estudantes que têm matrícula em mais de 2 disciplinas diferentes, junto com a quantidade de disciplinas e os dias da semana que têm aula.
SELECT
    es.NM_ESTUDANTE,
    es.CD_MATRICULA,
    qtde_disciplinas,
    dias_aula
FROM TB_Estudante es
JOIN (
    SELECT
        et.FK_ESTUDANTE,
        COUNT(DISTINCT t.FK_DISCIPLINA) AS qtde_disciplinas,
        STRING_AGG(DISTINCT h.TP_DIA_SEMANA, ', ') AS dias_aula
    FROM RL_Estudante_Turma et
    JOIN TB_Turma t ON et.FK_TURMA = t.ID_TURMA
    JOIN RL_Alocacao a ON t.ID_TURMA = a.FK_TURMA
    JOIN TB_Horario h ON a.FK_HORARIO = h.ID_HORARIO
    GROUP BY et.FK_ESTUDANTE
    HAVING COUNT(DISTINCT t.FK_DISCIPLINA) > 2
) sub ON es.ID_ESTUDANTE = sub.FK_ESTUDANTE
ORDER BY qtde_disciplinas DESC, es.NM_ESTUDANTE;

--Requisito: Gerenciar equipamentos disponíveis em cada sala
--Objetivo: Listar disciplinas que são ministradas em salas que não possuem computador, mesmo sendo de tipo "Laboratório"

SELECT
    d.NM_DISCIPLINA,
    s.NM_SALA,
    s.TP_SALA,
    e.NM_EQUIPAMENTO
FROM TB_Disciplina d
JOIN TB_Turma t ON d.ID_DISCIPLINA = t.FK_DISCIPLINA
JOIN RL_Alocacao a ON t.ID_TURMA = a.FK_TURMA
JOIN TB_Sala s ON a.FK_SALA = s.ID_SALA
LEFT JOIN RL_Sala_Equipamento se ON s.ID_SALA = se.FK_SALA
LEFT JOIN TB_Equipamento e ON se.FK_EQUIPAMENTO = e.ID_EQUIPAMENTO AND e.NM_EQUIPAMENTO = 'Computador'
WHERE s.TP_SALA = 'Laboratório' AND e.ID_EQUIPAMENTO IS NULL
GROUP BY d.NM_DISCIPLINA, s.NM_SALA, s.TP_SALA, e.NM_EQUIPAMENTO
ORDER BY s.NM_SALA;


--Requisito: Controlar disponibilidade de professores
--Objetivo: Listar os professores que ministram mais de uma turma em horários sobrepostos
SELECT
    p.NM_PROFESSOR,
    t1.ID_TURMA AS TURMA_1,
    h1.TP_DIA_SEMANA AS DIA_1,
    h1.DH_INICIO AS INICIO_1,
    h1.DH_FIM AS FIM_1,
    t2.ID_TURMA AS TURMA_2,
    h2.TP_DIA_SEMANA AS DIA_2,
    h2.DH_INICIO AS INICIO_2,
    h2.DH_FIM AS FIM_2
FROM TB_Professor p
JOIN TB_Turma t1 ON p.ID_PROFESSOR = t1.FK_PROFESSOR
JOIN RL_Alocacao a1 ON t1.ID_TURMA = a1.FK_TURMA
JOIN TB_Horario h1 ON a1.FK_HORARIO = h1.ID_HORARIO
JOIN TB_Turma t2 ON p.ID_PROFESSOR = t2.FK_PROFESSOR AND t1.ID_TURMA < t2.ID_TURMA
JOIN RL_Alocacao a2 ON t2.ID_TURMA = a2.FK_TURMA
JOIN TB_Horario h2 ON a2.FK_HORARIO = h2.ID_HORARIO
WHERE h1.TP_DIA_SEMANA = h2.TP_DIA_SEMANA
  AND (
      h1.DH_INICIO, h1.DH_FIM
  ) OVERLAPS (
      h2.DH_INICIO, h2.DH_FIM
  )
ORDER BY p.NM_PROFESSOR;

--Requisito: Gerar relatórios de ocupação
--Objetivo: Listar, para cada sala, o número total de turmas alocadas, o total de estudantes frequentando essas turmas e a média de ocupação por turma.
SELECT
    s.NM_SALA,
    COUNT(DISTINCT a.FK_TURMA) AS QTDE_TURMAS,
    COUNT(et.FK_ESTUDANTE) AS TOTAL_ESTUDANTES,
    ROUND(COUNT(et.FK_ESTUDANTE)::decimal / NULLIF(COUNT(DISTINCT a.FK_TURMA), 0), 2) AS MEDIA_ESTUDANTES_POR_TURMA
FROM TB_Sala s
JOIN RL_Alocacao a ON s.ID_SALA = a.FK_SALA
JOIN RL_Estudante_Turma et ON a.FK_TURMA = et.FK_TURMA
GROUP BY s.ID_SALA, s.NM_SALA
ORDER BY TOTAL_ESTUDANTES DESC;

--Requisito: Evitar conflitos de horário e superlotação
--Objetivo: Listar todos os casos em que a mesma sala está sendo usada por mais de uma turma no mesmo horário (ainda que horários não sejam idênticos).
SELECT
    s.NM_SALA,
    t1.ID_TURMA AS TURMA_1,
    h1.TP_DIA_SEMANA AS DIA,
    h1.DH_INICIO AS INICIO_1,
    h1.DH_FIM AS FIM_1,
    t2.ID_TURMA AS TURMA_2,
    h2.DH_INICIO AS INICIO_2,
    h2.DH_FIM AS FIM_2
FROM RL_Alocacao a1
JOIN RL_Alocacao a2
  ON a1.FK_SALA = a2.FK_SALA
 AND a1.FK_HORARIO <> a2.FK_HORARIO
JOIN TB_Horario h1 ON a1.FK_HORARIO = h1.ID_HORARIO
JOIN TB_Horario h2 ON a2.FK_HORARIO = h2.ID_HORARIO
JOIN TB_Turma t1 ON a1.FK_TURMA = t1.ID_TURMA
JOIN TB_Turma t2 ON a2.FK_TURMA = t2.ID_TURMA
JOIN TB_Sala s ON a1.FK_SALA = s.ID_SALA
WHERE t1.ID_TURMA < t2.ID_TURMA
  AND h1.TP_DIA_SEMANA = h2.TP_DIA_SEMANA
  AND (h1.DH_INICIO, h1.DH_FIM) OVERLAPS (h2.DH_INICIO, h2.DH_FIM)
ORDER BY s.NM_SALA, h1.TP_DIA_SEMANA;

--Requisito: Gerar relatórios sobre avaliações e notas dos estudantes
--Objetivo: Calcular a média ponderada das notas de cada estudante por turma, listando também o nome da disciplina e professor responsável.
SELECT
    e.NM_ESTUDANTE,
    d.NM_DISCIPLINA,
    p.NM_PROFESSOR,
    t.ID_TURMA,
    ROUND(SUM(r.NU_NOTA * a.NU_PESO) / SUM(a.NU_PESO), 2) AS MEDIA_PONDERADA
FROM RL_Avaliacao_Estudante r
JOIN TB_Avaliacao a ON r.FK_AVALIACAO = a.ID_AVALIACAO
JOIN TB_Turma t ON a.FK_TURMA = t.ID_TURMA
JOIN TB_Estudante e ON r.FK_ESTUDANTE = e.ID_ESTUDANTE
JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
JOIN TB_Professor p ON t.FK_PROFESSOR = p.ID_PROFESSOR
GROUP BY e.NM_ESTUDANTE, d.NM_DISCIPLINA, p.NM_PROFESSOR, t.ID_TURMA
ORDER BY e.NM_ESTUDANTE, d.NM_DISCIPLINA;

--Requisito: Gerar relatórios sobre avaliações e notas dos estudantes
--Objetivo: Identificar os estudantes com notas abaixo da média da turma em cada avaliação.
SELECT
    e.NM_ESTUDANTE,
    d.NM_DISCIPLINA,
    a.NM_AVALIACAO,
    r.NU_NOTA,
    ROUND(avg_turma.MEDIA_TURMA, 2) AS MEDIA_TURMA
FROM RL_Avaliacao_Estudante r
JOIN TB_Avaliacao a ON r.FK_AVALIACAO = a.ID_AVALIACAO
JOIN TB_Turma t ON a.FK_TURMA = t.ID_TURMA
JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
JOIN TB_Estudante e ON r.FK_ESTUDANTE = e.ID_ESTUDANTE
JOIN (
    SELECT
        FK_AVALIACAO,
        AVG(NU_NOTA) AS MEDIA_TURMA
    FROM RL_Avaliacao_Estudante
    GROUP BY FK_AVALIACAO
) AS avg_turma ON r.FK_AVALIACAO = avg_turma.FK_AVALIACAO
WHERE r.NU_NOTA < avg_turma.MEDIA_TURMA
ORDER BY d.NM_DISCIPLINA, a.NM_AVALIACAO, e.NM_ESTUDANTE;

--Requisito: Gerar relatórios sobre avaliações e notas dos estudantes
--Objetivo: Listar os três estudantes com maior média ponderada de notas em cada turma.
SELECT
    ranked.NM_ESTUDANTE,
    ranked.NM_DISCIPLINA,
    ranked.ID_TURMA,
    ranked.MEDIA_PONDERADA
FROM (
    SELECT
        e.NM_ESTUDANTE,
        d.NM_DISCIPLINA,
        t.ID_TURMA,
        ROUND(SUM(r.NU_NOTA * a.NU_PESO) / SUM(a.NU_PESO), 2) AS MEDIA_PONDERADA,
        RANK() OVER (PARTITION BY t.ID_TURMA ORDER BY SUM(r.NU_NOTA * a.NU_PESO) / SUM(a.NU_PESO) DESC) AS POSICAO
    FROM RL_Avaliacao_Estudante r
    JOIN TB_Avaliacao a ON r.FK_AVALIACAO = a.ID_AVALIACAO
    JOIN TB_Turma t ON a.FK_TURMA = t.ID_TURMA
    JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
    JOIN TB_Estudante e ON r.FK_ESTUDANTE = e.ID_ESTUDANTE
    GROUP BY e.NM_ESTUDANTE, d.NM_DISCIPLINA, t.ID_TURMA
) AS ranked
WHERE ranked.POSICAO <= 3
ORDER BY ranked.ID_TURMA, ranked.POSICAO;

--Requisito: Gerar relatórios sobre avaliações e notas dos estudantes
--Objetivo: Para cada disciplina, mostrar a quantidade total de avaliações aplicadas, a média geral das notas, e o número de estudantes avaliados.

SELECT
    d.NM_DISCIPLINA,
    COUNT(DISTINCT a.ID_AVALIACAO) AS TOTAL_AVALIACOES,
    ROUND(AVG(r.NU_NOTA), 2) AS MEDIA_GERAL_NOTAS,
    COUNT(DISTINCT r.FK_ESTUDANTE) AS QTD_ESTUDANTES_AVALIADOS
FROM TB_Disciplina d
JOIN TB_Turma t ON d.ID_DISCIPLINA = t.FK_DISCIPLINA
JOIN TB_Avaliacao a ON t.ID_TURMA = a.FK_TURMA
JOIN RL_Avaliacao_Estudante r ON a.ID_AVALIACAO = r.FK_AVALIACAO
GROUP BY d.NM_DISCIPLINA
ORDER BY d.NM_DISCIPLINA;

--Requisito: Gerar relatórios sobre avaliações e notas dos estudantes
--Objetivo: Listar os estudantes que não fizeram alguma avaliação importante (peso >= 5) em suas turmas, incluindo nome da avaliação, disciplina e data.
SELECT
    e.NM_ESTUDANTE,
    d.NM_DISCIPLINA,
    a.NM_AVALIACAO,
    a.DT_AVALIACAO,
    a.NU_PESO
FROM RL_Estudante_Turma et
JOIN TB_Turma t ON et.FK_TURMA = t.ID_TURMA
JOIN TB_Disciplina d ON t.FK_DISCIPLINA = d.ID_DISCIPLINA
JOIN TB_Avaliacao a ON t.ID_TURMA = a.FK_TURMA
JOIN TB_Estudante e ON et.FK_ESTUDANTE = e.ID_ESTUDANTE
LEFT JOIN RL_Avaliacao_Estudante ra ON a.ID_AVALIACAO = ra.FK_AVALIACAO AND e.ID_ESTUDANTE = ra.FK_ESTUDANTE
WHERE a.NU_PESO >= 5 AND ra.NU_NOTA IS NULL
ORDER BY e.NM_ESTUDANTE, a.DT_AVALIACAO;
