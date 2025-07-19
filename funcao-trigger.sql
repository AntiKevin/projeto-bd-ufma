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

-- trigger para atualizar a média de resolução ao fechar um chamado
CREATE OR REPLACE FUNCTION atualizar_media_resolucao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_fechamento IS NOT NULL THEN
        UPDATE Tecnico
        SET media_resolucao = (
            SELECT ROUND(AVG(EXTRACT(DAY FROM (c.data_fechamento - c.data_abertura)))::NUMERIC, 2)
            FROM Chamado c
            JOIN Atribuicao a ON c.id_chamado = a.id_chamado
            WHERE a.id_tecnico = NEW.id_usuario
            AND c.data_fechamento IS NOT NULL
        )
        WHERE id_usuario = NEW.id_usuario;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;