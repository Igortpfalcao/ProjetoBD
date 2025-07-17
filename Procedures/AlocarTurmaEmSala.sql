CREATE OR REPLACE FUNCTION sp_cadastrar_alocacao(
    p_id_turma INTEGER,
    p_id_sala INTEGER,
    p_id_horario INTEGER
)
RETURNS TEXT AS $$
DECLARE
    sala_ocupada INTEGER;
    alocacao_existente RECORD;
BEGIN
    -- Início da transação
    BEGIN

        -- SELECT 1: Verificar se a sala já está ocupada nesse horário
        SELECT COUNT(*) INTO sala_ocupada
        FROM RL_Alocacao
        WHERE FK_SALA = p_id_sala AND FK_HORARIO = p_id_horario;

        IF sala_ocupada > 0 THEN
            RETURN 'Erro: Sala já está ocupada neste horário.';
        END IF;

        -- SELECT 2: Verificar se a turma já possui alocação
        SELECT * INTO alocacao_existente
        FROM RL_Alocacao
        WHERE FK_TURMA = p_id_turma;

        -- DELETE: Remove alocação anterior da turma (se houver)
        IF FOUND THEN
            DELETE FROM RL_Alocacao
            WHERE FK_TURMA = p_id_turma;
        END IF;

        -- INSERT: Cadastrar nova alocação
        INSERT INTO RL_Alocacao(FK_TURMA, FK_SALA, FK_HORARIO)
        VALUES (p_id_turma, p_id_sala, p_id_horario);

        -- UPDATE 1: Atualiza status da turma para "ALOCADA"
        UPDATE TB_Turma
        SET ST_TURMA = 'ALOCADA'
        WHERE ID_TURMA = p_id_turma;

        -- UPDATE 2: atualizar tipo da sala para "EM USO"
        UPDATE TB_Sala
        SET TP_SALA = 'EM USO'
        WHERE ID_SALA = p_id_sala;


        COMMIT;
        RETURN 'Alocação realizada com sucesso.';

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RETURN 'Erro ao realizar alocação: ' || SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;
