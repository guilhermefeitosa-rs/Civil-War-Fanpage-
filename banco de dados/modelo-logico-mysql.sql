-- Guerra Civil — Guia de Leitura · modelo lógico em 3FN (MySQL 8.0.16 ou superior, InnoDB)

CREATE DATABASE IF NOT EXISTS guerra_civil CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE guerra_civil;

CREATE TABLE editora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE serie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    editora_id INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    UNIQUE (editora_id, nome),
    CHECK (tipo IN ('Minissérie principal', 'Tie-in')),
    FOREIGN KEY (editora_id) REFERENCES editora(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE edicao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    serie_id INT NOT NULL,
    numero INT NOT NULL,
    posicao_leitura INT NOT NULL UNIQUE,
    descricao TEXT,
    UNIQUE (serie_id, numero),
    CHECK (numero > 0),
    CHECK (posicao_leitura > 0),
    FOREIGN KEY (serie_id) REFERENCES serie(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE perfil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL UNIQUE,
    descricao VARCHAR(120) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE recurso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao VARCHAR(120)
) ENGINE=InnoDB;

-- Tabela associativa N:N (Perfil x Recurso), com chave primária composta
CREATE TABLE perfil_recurso (
    perfil_id INT NOT NULL,
    recurso_id INT NOT NULL,
    permitido BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (perfil_id, recurso_id),
    FOREIGN KEY (perfil_id) REFERENCES perfil(id) ON DELETE CASCADE,
    FOREIGN KEY (recurso_id) REFERENCES recurso(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    perfil_id INT NOT NULL DEFAULT 2,          -- 2 = Leitor (ver dados iniciais abaixo)
    nome VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    data_cadastro DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (perfil_id) REFERENCES perfil(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabela associativa N:N (Usuário x Edição): uma linha = edição lida
CREATE TABLE leitura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    edicao_id INT NOT NULL,
    data_leitura DATE NOT NULL DEFAULT (CURRENT_DATE),
    UNIQUE (usuario_id, edicao_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (edicao_id) REFERENCES edicao(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ===== Dados iniciais (necessários para o DEFAULT 2 do usuário funcionar) =====
INSERT INTO editora (id, nome) VALUES (1, 'Marvel Comics');

INSERT INTO perfil (id, nome, descricao) VALUES
    (1, 'Visitante', 'Pessoa sem cadastro no site'),
    (2, 'Leitor', 'Usuário cadastrado e logado'),
    (3, 'Administrador', 'Responsável pelo projeto');

INSERT INTO recurso (id, nome) VALUES
    (1, 'Páginas públicas e lista de edições (leitura)'),
    (2, 'Progresso de leitura salvo'),
    (3, 'Gestão de séries e edições'),
    (4, 'Gestão de usuários');

INSERT INTO perfil_recurso (perfil_id, recurso_id, permitido) VALUES
    (1, 1, TRUE),  (1, 2, FALSE), (1, 3, FALSE), (1, 4, FALSE),
    (2, 1, TRUE),  (2, 2, TRUE),  (2, 3, FALSE), (2, 4, FALSE),
    (3, 1, TRUE),  (3, 2, TRUE),  (3, 3, TRUE),  (3, 4, TRUE);
