-- 1. Tabela Usuário (entidade base)
CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('Cliente', 'Técnico')) -- Discriminador para especialização
);

-- 2. Tabela Departamento
CREATE TABLE Departamento (
    id_departamento SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT
);

-- 3. Tabela Técnico (especialização de Usuário)
CREATE TABLE Tecnico (
    id_usuario INT PRIMARY KEY, -- PK que também é FK para Usuario
    registro VARCHAR(100) NOT NULL,
    data_admissao DATE NOT NULL,
    id_departamento INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento) ON DELETE SET NULL
);

-- 4. Tabela Chamado
CREATE TABLE Chamado (
    id_chamado SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    status VARCHAR(50) DEFAULT 'Aberto',
    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fechamento TIMESTAMP,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

-- 5. Tabela Comentário
CREATE TABLE Comentario (
    id_comentario SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    id_chamado INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_chamado) REFERENCES Chamado(id_chamado) ON DELETE CASCADE
);

-- 6. Tabela Atribuicao (relacionamento N:N entre Técnico e Chamado)
CREATE TABLE Atribuicao (
    id_tecnico INT NOT NULL,
    id_chamado INT NOT NULL,
    data_atribuicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_tecnico, id_chamado),
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_chamado) REFERENCES Chamado(id_chamado) ON DELETE CASCADE
);