CREATE DATABASE hospital_plano
GO
USE hospital_plano
GO
CREATE TABLE plano_saude
(
    codigo INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    telefone CHAR(13) NOT NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE paciente 
(
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    telefone CHAR(13) NOT NULL,
    plano_saude INT NOT NULL
    PRIMARY KEY (cpf)
    FOREIGN KEY (plano_saude) REFERENCES plano_saude(codigo)
)
GO
CREATE TABLE medico 
(
    codigo INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL,
    plano_saude INT NOT NULL
    PRIMARY KEY (codigo)
    FOREIGN KEY (plano_saude) REFERENCES plano_saude(codigo)
)
GO
CREATE TABLE consulta
(
    codigo_medico INT NOT NULL,
    cpf_paciente CHAR(11) NOT NULL,
    datahora DATETIME NOT NULL,
    diagnostico VARCHAR(50) NOT NULL
    PRIMARY KEY (codigo_medico, cpf_paciente, datahora)
    FOREIGN KEY (codigo_medico) REFERENCES medico(codigo),
    FOREIGN KEY (cpf_paciente) REFERENCES paciente(cpf)
)

INSERT INTO plano_saude 
VALUES
(1234, 'Amil', '41599856'),
(2345, 'Sul Am�rica', '45698745'),
(3456, 'Unimed', '48759836'),
(4567, 'Bradesco Sa�de', '47265897'),
(5678, 'Interm�dica', '41415269')

INSERT INTO paciente 
VALUES
('85987458920', 'Maria Paula', 'R. Volunt�rios da P�tria', 589, 'Santana', '98458741', 2345),
('87452136900', 'Ana Julia', 'R. XV de Novembro', 657, 'Centro', '69857412', 5678),
('23659874100', 'Jo�o Carlos', 'R. Sete de Setembro', 12, 'Rep�blica', '74859632', 1234),
('63259874100', 'Jos� Lima', 'R. Anhaia', 768, 'Barra Funda', '96524156', 2345)

INSERT INTO medico 
VALUES
('Claudio', 'Cl�nico Geral', 1234),
('Larissa', 'Ortopedista', 2345),
('Juliana', 'Otorrinolaringologista', 4567),
('S�rgio', 'Pediatra', 1234),
('Julio', 'Cl�nico Geral', 4567),
('Samara', 'Cirurgi�o', 1234)

INSERT INTO consulta 
VALUES
(1, '85987458920', '2021-02-10 10:30:00', 'Gripe'),
(2, '23659874100', '2021-02-10 11:00:00', 'P� Fraturado'),
(4, '85987458920', '2021-02-11 14:00:00', 'Pneumonia'),
(1, '23659874100', '2021-02-11 15:00:00', 'Asma'),
(3, '87452136900', '2021-02-11 16:00:00', 'Sinusite'),
(5, '63259874100', '2021-02-11 17:00:00', 'Rinite'),
(4, '23659874100', '2021-02-11 18:00:00', 'Asma'),
(5, '63259874100', '2021-02-12 10:00:00', 'Rinoplastia')

--Consultar Nome e especialidade dos m�dicos da Amil
SELECT m.nome, m.especialidade
FROM medico m, plano_saude p
WHERE m.plano_saude = p.codigo AND p.nome LIKE 'Amil'
--Consultar Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes
SELECT pa.nome, CONCAT(pa.bairro,' ',pa.rua,' ',pa.numero) AS endereco, pa.telefone, p.nome
FROM paciente pa, plano_saude p
WHERE p.codigo = pa.plano_saude
--Consultar Telefone do Plano de  Sa�de de Ana J�lia
SELECT p.telefone, pa.nome
FROM plano_saude p, paciente pa
WHERE p.codigo = pa.plano_saude AND pa.nome LIKE 'Ana%'
--Consultar Plano de Sa�de que n�o tem pacientes cadastrados
SELECT p.codigo,p.nome
FROM plano_saude p LEFT JOIN paciente pa ON p.codigo = pa.plano_saude
WHERE pa.cpf IS NULL
--Consultar Planos de Sa�de que n�o tem m�dicos cadastrados
SELECT p.*
FROM plano_saude p LEFT JOIN medico m ON p.codigo = m.plano_saude
WHERE m.codigo IS NULL
--Consultar Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas
SELECT CONVERT(varchar,c.datahora,103) as data, CONVERT(varchar,c.datahora,108) as hora, m.nome as medico, p.nome as paciente, c.diagnostico
FROM consulta c, medico m, paciente p
WHERE c.cpf_paciente = p.cpf AND c.codigo_medico = m.codigo
--Consultar Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima
SELECT m.nome, c.datahora, c.diagnostico
FROM medico m, consulta c, paciente p
WHERE c.cpf_paciente = p.cpf AND c.codigo_medico = m.codigo AND p.nome LIKE 'Jos�%'
--Consultar Diagn�stico e Quantidade de consultas que aquele diagn�stico foi dado (Coluna deve chamar qtd)
SELECT c.diagnostico, COUNT(c.diagnostico) as qtd
FROM consulta c
GROUP BY c.diagnostico
--Consultar Quantos Planos de Sa�de que n�o tem m�dicos cadastrados
SELECT COUNT(p.codigo) as qnt
FROM plano_saude p LEFT JOIN medico m ON p.codigo = m.plano_saude
WHERE m.codigo IS NULL