-- Função para calcular a média de dias de resolução de chamados por técnico
CREATE OR REPLACE FUNCTION calcular_media_resolucao(p_id_tecnico INT)
RETURNS TABLE(media_dias NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ROUND(AVG(EXTRACT(DAY FROM (c.data_fechamento - c.data_abertura)))::NUMERIC, 2)
    FROM 
        Chamado c
    JOIN 
        Atribuicao a ON c.id_chamado = a.id_chamado
    WHERE 
        a.id_tecnico = p_id_tecnico
        AND c.data_fechamento IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

-- Função de trigger para atualizar estatística de média de resolução
CREATE OR REPLACE FUNCTION atualizar_media_resolucao()
RETURNS TRIGGER AS $$
DECLARE
    v_media NUMERIC;
    v_tecnico INT;
BEGIN
    IF NEW.data_fechamento IS NOT NULL THEN
        -- para cada técnico atribuído ao chamado
        FOR v_tecnico IN
            SELECT id_tecnico FROM Atribuicao WHERE id_chamado = NEW.id_chamado
        LOOP
            -- calcula média de dias de resolução
            SELECT ROUND(AVG(EXTRACT(DAY FROM (c.data_fechamento - c.data_abertura)))::NUMERIC, 2)
            INTO v_media
            FROM Chamado c
            JOIN Atribuicao a ON c.id_chamado = a.id_chamado
            WHERE a.id_tecnico = v_tecnico
              AND c.data_fechamento IS NOT NULL;

            -- insere ou atualiza na tabela de estatísticas
            INSERT INTO EstatisticaResolucao(id_tecnico, media_dias, data_atualizacao)
            VALUES (v_tecnico, v_media, CURRENT_TIMESTAMP)
            ON CONFLICT (id_tecnico)
            DO UPDATE SET media_dias = EXCLUDED.media_dias,
                          data_atualizacao = EXCLUDED.data_atualizacao;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger para disparar após fechamento do chamado
DROP TRIGGER IF EXISTS trg_atualizacao_media ON Chamado;
CREATE TRIGGER trg_atualizacao_media
AFTER UPDATE OF data_fechamento ON Chamado
FOR EACH ROW
WHEN (NEW.data_fechamento IS NOT NULL)
EXECUTE FUNCTION atualizar_media_resolucao();