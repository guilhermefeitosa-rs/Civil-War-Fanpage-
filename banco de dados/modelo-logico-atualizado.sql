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

-- ===== Dados de exemplo (adaptados do gabarito da Aula 07) =====
-- Ids gerados por AUTO_INCREMENT, com o banco vazio e os dados iniciais acima já inseridos.

-- 1. Séries (5): as edições abaixo pertencem a elas. Ids 1 a 5, na ordem.
INSERT INTO serie (editora_id, nome, tipo) VALUES
    (1, 'Amazing Spider-Man',      'Tie-in'),
    (1, 'Thunderbolts',            'Tie-in'),
    (1, 'Sensational Spider-Man',  'Tie-in'),
    (1, 'Civil War: Front Line',   'Tie-in'),
    (1, 'Civil War',               'Minissérie principal');

-- 2. Edições (5): as 4 primeiras da lista de leitura e Civil War #3. Ids 1 a 5.
--    A descrição fica vazia (NULL), como no projeto.
INSERT INTO edicao (serie_id, numero, posicao_leitura) VALUES
    (1, 533,  1),
    (2, 103,  2),
    (3,  28,  3),
    (4,   2,  4),
    (5,   3, 49);

-- 3. Usuários (5): Carla é Administradora (perfil 3); os demais são Leitores (perfil 2).
INSERT INTO usuario (nome, email, perfil_id, data_cadastro) VALUES
    ('Ana Souza',    'ana@mail.com',    2, '2026-10-20'),
    ('Bruno Lima',   'bruno@mail.com',  2, '2026-10-22'),
    ('Carla Mendes', 'carla@mail.com',  3, '2026-10-15'),
    ('Daniel Rocha', 'daniel@mail.com', 2, '2026-10-25'),
    ('Eduarda Melo', 'edu@mail.com',    2, '2026-10-28');

-- 4. Leituras (10 linhas): equivalem aos 8 pedidos + 10 itens do gabarito.
--    Aqui não há tabela "pedido": o usuário e a data vêm direto na leitura.
--    UNIQUE (usuario_id, edicao_id): ninguém lê a mesma edição duas vezes.
INSERT INTO leitura (usuario_id, edicao_id, data_leitura) VALUES
    (1, 1, '2026-11-01'), (1, 2, '2026-11-01'),   -- Ana
    (2, 1, '2026-11-03'),                         -- Bruno
    (1, 3, '2026-11-05'),                         -- Ana
    (3, 5, '2026-11-07'),                         -- Carla
    (4, 2, '2026-11-09'), (4, 1, '2026-11-09'),   -- Daniel
    (5, 3, '2026-11-10'),                         -- Eduarda
    (1, 5, '2026-11-11'),                         -- Ana
    (3, 1, '2026-11-12');                         -- Carla
