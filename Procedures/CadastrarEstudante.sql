CREATE OR REPLACE PROCEDURE sp_cadastrar_estudante_completo(
    p_nome_estudante VARCHAR,
    p_matricula VARCHAR,
    p_id_turma INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_estudante INTEGER;
    v_count INTEGER;
    v_status_turma VARCHAR(20);
BEGIN
    BEGIN
        -- SELECT 1: Verifica se a matrícula já existe
        SELECT COUNT(*) INTO v_count
        FROM TB_Estudante
        WHERE CD_MATRICULA = p_matricula;

        IF v_count > 0 THEN
            RAISE EXCEPTION 'Matrícula % já cadastrada.', p_matricula;
        END IF;

        -- SELECT 2: Verifica se a turma existe e obtém o status
        SELECT ST_TURMA INTO v_status_turma
        FROM TB_Turma
        WHERE ID_TURMA = p_id_turma;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Turma com ID % não existe.', p_id_turma;
        END IF;
        
        IF v_status_turma <> 'Ativa' THEN
            RAISE EXCEPTION 'Turma com ID % está inativa.', p_id_turma;
        END IF;

        -- INSERT 1: Insere novo estudante
        INSERT INTO TB_Estudante(NM_ESTUDANTE, CD_MATRICULA)
        VALUES (p_nome_estudante, p_matricula)
        RETURNING ID_ESTUDANTE INTO v_id_estudante;

        -- INSERT 2: Relaciona estudante com turma
        INSERT INTO RL_Estudante_Turma(FK_ESTUDANTE, FK_TURMA)
        VALUES (v_id_estudante, p_id_turma);

        -- UPDATE 1: Atualiza nome para capitalizado
        UPDATE TB_Estudante
        SET NM_ESTUDANTE = INITCAP(NM_ESTUDANTE)
        WHERE ID_ESTUDANTE = v_id_estudante;

        -- UPDATE 2: Atualiza data da última matrícula
        UPDATE TB_Estudante
        SET DT_ULTIMA_MATRICULA = CURRENT_DATE
        WHERE ID_ESTUDANTE = v_id_estudante;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Erro durante cadastro: %', SQLERRM;
            RAISE;
    END;
END;
$$;
