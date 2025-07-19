-- consulta para contar o número de técnicos por departamento
SELECT 
    d.id_departamento,
    d.nome AS nome_departamento,
    COUNT(t.id_usuario) AS total_tecnicos
FROM 
    Departamento d
JOIN 
    Tecnico t ON d.id_departamento = t.id_departamento
GROUP BY 
    d.id_departamento, d.nome
HAVING 
    COUNT(t.id_usuario) > 3
ORDER BY 
    total_tecnicos DESC;