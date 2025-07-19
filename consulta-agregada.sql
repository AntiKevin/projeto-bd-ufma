-- Numero de chamados abertos por usuário
-- Esta consulta retorna o número de chamados abertos por cada usuário, ordenados pelo total de chamados em ordem decrescente.
SELECT 
    u.id_usuario,
    u.nome,
    COUNT(c.id_chamado) AS total_chamados
FROM 
    Usuario u
JOIN 
    Chamado c ON u.id_usuario = c.id_usuario
WHERE 
    c.status = 'Aberto'
GROUP BY 
    u.id_usuario, u.nome
ORDER BY 
    total_chamados DESC;