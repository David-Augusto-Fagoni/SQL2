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
(2345, 'Sul América', '45698745'),
(3456, 'Unimed', '48759836'),
(4567, 'Bradesco Saúde', '47265897'),
(5678, 'Intermédica', '41415269')

INSERT INTO paciente 
VALUES
('85987458920', 'Maria Paula', 'R. Voluntários da Pátria', 589, 'Santana', '98458741', 2345),
('87452136900', 'Ana Julia', 'R. XV de Novembro', 657, 'Centro', '69857412', 5678),
('23659874100', 'João Carlos', 'R. Sete de Setembro', 12, 'República', '74859632', 1234),
('63259874100', 'José Lima', 'R. Anhaia', 768, 'Barra Funda', '96524156', 2345)

INSERT INTO medico 
VALUES
('Claudio', 'Clínico Geral', 1234),
('Larissa', 'Ortopedista', 2345),
('Juliana', 'Otorrinolaringologista', 4567),
('Sérgio', 'Pediatra', 1234),
('Julio', 'Clínico Geral', 4567),
('Samara', 'Cirurgião', 1234)

INSERT INTO consulta 
VALUES
(1, '85987458920', '2021-02-10 10:30:00', 'Gripe'),
(2, '23659874100', '2021-02-10 11:00:00', 'Pé Fraturado'),
(4, '85987458920', '2021-02-11 14:00:00', 'Pneumonia'),
(1, '23659874100', '2021-02-11 15:00:00', 'Asma'),
(3, '87452136900', '2021-02-11 16:00:00', 'Sinusite'),
(5, '63259874100', '2021-02-11 17:00:00', 'Rinite'),
(4, '23659874100', '2021-02-11 18:00:00', 'Asma'),
(5, '63259874100', '2021-02-12 10:00:00', 'Rinoplastia')

--Consultar Nome e especialidade dos médicos da Amil
SELECT m.nome, m.especialidade
FROM medico m, plano_saude p
WHERE m.plano_saude = p.codigo AND p.nome LIKE 'Amil'
--Consultar Nome, Endereço concatenado, Telefone e Nome do Plano de Saúde de todos os pacientes
SELECT pa.nome, CONCAT(pa.bairro,' ',pa.rua,' ',pa.numero) AS endereco, pa.telefone, p.nome
FROM paciente pa, plano_saude p
WHERE p.codigo = pa.plano_saude
--Consultar Telefone do Plano de  Saúde de Ana Júlia
SELECT p.telefone, pa.nome
FROM plano_saude p, paciente pa
WHERE p.codigo = pa.plano_saude AND pa.nome LIKE 'Ana%'
--Consultar Plano de Saúde que não tem pacientes cadastrados
SELECT p.codigo,p.nome
FROM plano_saude p LEFT JOIN paciente pa ON p.codigo = pa.plano_saude
WHERE pa.cpf IS NULL
--Consultar Planos de Saúde que não tem médicos cadastrados
SELECT p.*
FROM plano_saude p LEFT JOIN medico m ON p.codigo = m.plano_saude
WHERE m.codigo IS NULL
--Consultar Data da consulta, Hora da consulta, nome do médico, nome do paciente e diagnóstico de todas as consultas
SELECT CONVERT(varchar,c.datahora,103) as data, CONVERT(varchar,c.datahora,108) as hora, m.nome as medico, p.nome as paciente, c.diagnostico
FROM consulta c, medico m, paciente p
WHERE c.cpf_paciente = p.cpf AND c.codigo_medico = m.codigo
--Consultar Nome do médico, data e hora de consulta e diagnóstico de José Lima
SELECT m.nome, c.datahora, c.diagnostico
FROM medico m, consulta c, paciente p
WHERE c.cpf_paciente = p.cpf AND c.codigo_medico = m.codigo AND p.nome LIKE 'José%'
--Consultar Diagnóstico e Quantidade de consultas que aquele diagnóstico foi dado (Coluna deve chamar qtd)
SELECT c.diagnostico, COUNT(c.diagnostico) as qtd
FROM consulta c
GROUP BY c.diagnostico
--Consultar Quantos Planos de Saúde que não tem médicos cadastrados
SELECT COUNT(p.codigo) as qnt
FROM plano_saude p LEFT JOIN medico m ON p.codigo = m.plano_saude
WHERE m.codigo IS NULL