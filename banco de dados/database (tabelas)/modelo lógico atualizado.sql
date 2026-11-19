-- Guerra Civil — Guia de Leitura · modelo lógico em 3FN (SQL padrão)
-- Testado em SQLite com PRAGMA foreign_keys = ON. Em MySQL, use DEFAULT (CURRENT_DATE).

CREATE TABLE editora (
  id INT NOT NULL,
  nome VARCHAR(40) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (nome)
);

CREATE TABLE serie (
  id INT NOT NULL,
  editora_id INT NOT NULL,
  nome VARCHAR(80) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (editora_id, nome),
  CHECK (tipo IN ('Minissérie principal','Tie-in')),
  FOREIGN KEY (editora_id) REFERENCES editora (id) ON DELETE RESTRICT
);

CREATE TABLE edicao (
  id INT NOT NULL,
  serie_id INT NOT NULL,
  numero INT NOT NULL,
  posicao_leitura INT NOT NULL,
  descricao TEXT,
  PRIMARY KEY (id),
  UNIQUE (posicao_leitura),
  UNIQUE (serie_id, numero),
  CHECK (numero > 0),
  CHECK (posicao_leitura > 0),
  FOREIGN KEY (serie_id) REFERENCES serie (id) ON DELETE RESTRICT
);

CREATE TABLE perfil (
  id INT NOT NULL,
  nome VARCHAR(30) NOT NULL,
  descricao VARCHAR(120) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (nome)
);

CREATE TABLE recurso (
  id INT NOT NULL,
  nome VARCHAR(60) NOT NULL,
  descricao VARCHAR(120),
  PRIMARY KEY (id),
  UNIQUE (nome)
);

CREATE TABLE perfil_recurso (
  perfil_id INT NOT NULL,
  recurso_id INT NOT NULL,
  permitido BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (perfil_id, recurso_id),
  FOREIGN KEY (perfil_id) REFERENCES perfil (id) ON DELETE CASCADE,
  FOREIGN KEY (recurso_id) REFERENCES recurso (id) ON DELETE CASCADE
);

CREATE TABLE usuario (
  id INT NOT NULL,
  perfil_id INT NOT NULL DEFAULT 2,
  nome VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL,
  data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (id),
  UNIQUE (email),
  FOREIGN KEY (perfil_id) REFERENCES perfil (id) ON DELETE RESTRICT
);

CREATE TABLE sessao_leitura (
  id INT NOT NULL,
  usuario_id INT NOT NULL,
  data_leitura DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (id),
  FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE
);

CREATE TABLE item_leitura (
  sessao_id INT NOT NULL,
  edicao_id INT NOT NULL,
  PRIMARY KEY (sessao_id, edicao_id),
  FOREIGN KEY (sessao_id) REFERENCES sessao_leitura (id) ON DELETE CASCADE,
  FOREIGN KEY (edicao_id) REFERENCES edicao (id) ON DELETE RESTRICT
);
