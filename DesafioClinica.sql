-- 1. Criando o Banco de Dados -- 
CREATE DATABASE Clinica;
USE Clinica;

-- 2. Criando as tabelas -- 
-- Tabela Ambulatorios
CREATE TABLE Ambulatorios (
    nroa int PRIMARY KEY,
    andar numeric(3) NOT NULL,
    capacidade smallint
);

-- Tabela Medicos
CREATE TABLE Medicos (
    codm int PRIMARY KEY,
    nome varchar(40) NOT NULL,
    idade smallint NOT NULL,
    especialidade char(20),
    CPF numeric(11) UNIQUE,
    cidade varchar(30),
    fk_nroa int,
    FOREIGN KEY (fk_nroa) REFERENCES Ambulatorios(nroa)
);

-- Tabela Pacientes
CREATE TABLE Pacientes (
    codp int PRIMARY KEY,
    nome varchar(40) NOT NULL,
    idade smallint NOT NULL,
    cidade char(30),
    CPF numeric(11) UNIQUE,
    doenca varchar(40) NOT NULL
);

-- Tabela Funcionarios
CREATE TABLE Funcionarios (
    codf int PRIMARY KEY,
    nome varchar(40) NOT NULL,
    idade smallint,
    CPF numeric(11) UNIQUE,
    cidade varchar(30),
    salario numeric(10),
    cargo varchar(20)
);

-- Tabela Consultas
CREATE TABLE Consultas (
    fk_codm int,
    fk_codp int,
    data_Consulta date,
    hora time,
	FOREIGN KEY (fk_codm) REFERENCES Medicos(codm),
    FOREIGN KEY (fk_codp) REFERENCES Pacientes(codp)
);

-- 3. Criando uma nova coluna na tabela Funcionarios --
 ALTER TABLE Funcionarios ADD nroa int;
 
 -- 4. Criando os índices--
CREATE UNIQUE INDEX idx_Medicos_CPF ON Medicos (CPF);
CREATE INDEX idx_Pacientes_doenca ON Pacientes (doenca);

-- 5. Removendo o índice doenca em Pacientes --
ALTER TABLE Pacientes DROP INDEX idx_Pacientes_doenca;

-- 6. Removendo as colunas cargo e nroa da tabela Funcionários --
ALTER TABLE Funcionarios DROP COLUMN cargo;
ALTER TABLE Funcionarios DROP COLUMN nroa;

-- 7. Inserindo os dados nas tabelas -- 
-- Inserindo dados na tabela Ambulatorios
INSERT INTO Ambulatorios (nroa, andar, capacidade)
VALUES
(1, 1, 30),
(2, 1, 50),
(3, 2, 40),
(4, 2, 25),
(5, 2, 55);

-- Inserindo dados na tabela Medicos
INSERT INTO Medicos (codm, nome, idade, especialidade, CPF, cidade, fk_nroa)
VALUES
(1, 'João', 40, 'ortopedia', 10000100000, 'Florianopolis', 1),
(2, 'Maria', 42, 'traumatologia', 10000110000, 'Blumenau', 2),
(3, 'Pedro', 51, 'pediatria', 11000100000, 'SãoJosé', 2),
(4, 'Carlos', 28, 'ortopedia', 100011000, 'Joinville', 1),
(5, 'Marcia', 33, 'neurologia', 11000111000, 'Biguacu', 3);

-- Inserindo dados na tabela Pacientes
INSERT INTO Pacientes (codp, nome, idade, cidade, CPF, doenca)
VALUES
    (1, 'Ana', 20, 'Florianópolis', 20000200000, 'gripe'),
    (2, 'Paulo', 24, 'Palhoça', 22000220000, 'fratura'),
    (3, 'Lucia', 30, 'Biguaçu', 22000200000, 'tendinite'),
    (4, 'Carlos', 28, 'Joinville', 11000110000, 'sarampo');
    
-- Inserindo dados na tabela Funcionarios
INSERT INTO Funcionarios (codf, nome, idade, cidade, salario, CPF)
VALUES
    (1, 'Rita', 32, 'São José', 1200, 12002000010),
    (2, 'Maria', 55, 'Palhoça', 1220, 12203000011),
    (3, 'Caio', 45, 'Florianópolis', 1100, 11004100010),
    (4, 'Carlos', 44, 'Florianópolis', 1200, 12005100011),
    (5, 'Paula', 33, 'Florianópolis', 2500, 25006100011);
    
-- Inserindo dados na tabela Consultas
INSERT INTO Consultas (fk_codm, fk_codp, data_Consulta, hora)
VALUES
    (1, 1, '2006-06-12', '14:00'),
    (1, 4, '2006-06-13', '10:00'),
    (2, 1, '2006-06-13', '09:00'),
    (2, 2, '2006-06-13', '11:00'),
    (2, 3, '2006-06-14', '14:00'),
    (2, 4, '2006-06-14', '17:00'),
    (3, 1, '2006-06-19', '18:00'),
    (3, 3, '2006-06-12', '10:00'),
    (3, 4, '2006-06-19', '13:00'),
    (4, 4, '2006-06-20', '13:00'),
    (4, 4, '2006-06-22', '19:30');
    
-- Realizando atualizações --
-- 1. O paciente Paulo mudou-se para Ilhota -- 
UPDATE Pacientes 
SET cidade = 'Ilhota'
WHERE codp = 2; 

-- Verificando a atualização-- 
SELECT * FROM Pacientes; 
    
-- 2. A consulta do médico 1 com o paciente 4  passou para às 12:00 horas do dia 4 de Julho de 2006 --    
UPDATE Consultas
SET data_Consulta = '2006-07-04',
	hora = '12:00'
WHERE fk_codm = 1 and fk_codp = 4; 

-- Verificando a atualização-- 
SELECT * FROM Consultas; 

-- 3. A paciente Ana fez aniversário e sua doença agora é cancer
UPDATE Pacientes
SET idade = '21',
	doenca = 'câncer'
WHERE codp = 1;

-- 4. A consulta do médico Pedro (codf = 3) com o paciente Carlos (codp = 4) passou para uma hora e meia depois
UPDATE Consultas
SET hora = '14:30'
WHERE fk_codm = 3 and fk_codp = 4; 

-- 5. O funcionário Carlos (codf = 4) deixou a clínica
DELETE FROM Funcionarios WHERE codf = 4;

-- Verificando a atualização-- 
SELECT * FROM Funcionarios; 

-- 6. As consultas marcadas após as 19 horas foram canceladas
DELETE FROM Consultas WHERE hora > '19:00';

-- 7. Os pacientes com câncer ou idade inferior a 10 anos deixaram a clínica 
DELETE FROM Pacientes 
WHERE doenca = 'câncer' OR idade < '10';
 
 -- 8. Os médicos que residem em Biguacu e Palhoca deixaram a clínica
DELETE FROM Medicos WHERE cidade IN ('Biguaçu', 'Palhoça');
 
 -- Verificando a atualização-- 
SELECT * FROM Medicos; 
