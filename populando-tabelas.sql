INSERT INTO Usuario (nome, email, senha, tipo)
VALUES ('João Silva', 'joao@email.com', 'senha123', 'Cliente');


-- Inserindo Técnico e Departamento
INSERT INTO Usuario (nome, email, senha, tipo)
VALUES ('Ana Souza', 'ana@email.com', 'senha456', 'Técnico');

INSERT INTO Tecnico (id_usuario, registro, data_admissao, id_departamento)
VALUES (2, 'REG-789', '2023-01-15', 1);

INSERT INTO Departamento (nome, descricao)
VALUES ('Suporte Técnico', 'Departamento responsável pelo suporte técnico aos clientes');

-- Inserindo Chamado
INSERT INTO Chamado (titulo, descricao, id_usuario)
VALUES ('Problema com Impressora', 'A impressora não está funcionando corretamente.', 1);

-- Inserindo Atribuição de Chamado
INSERT INTO Atribuicao (id_tecnico, id_chamado)
VALUES (2, 1);

-- Inserindo Comentário
INSERT INTO Comentario (texto, id_usuario, id_chamado)
VALUES ('Estou verificando o problema.', 2, 1);
INSERT INTO Comentario (texto, id_usuario, id_chamado)
VALUES ('A impressora foi consertada.', 2, 1);
