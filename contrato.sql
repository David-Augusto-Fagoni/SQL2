CREATE DATABASE contrato
GO
USE contrato
GO
CREATE TABLE plano 
(
    codigo INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(25) NOT NULL,
    valor DECIMAL(7, 2) NOT NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE servico
(
    codigo INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    valor DECIMAL(7, 2) NOT NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE cliente
(
    codigo INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE contrato
(
    cod_cliente INT NOT NULL,
    cod_plano INT NOT NULL,
    cod_servico INT NOT NULL,
    status CHAR(1) NOT NULL,
    data_contrato DATE NOT NULL
    PRIMARY KEY (cod_cliente, cod_plano, cod_servico, data_contrato)
    FOREIGN KEY (cod_cliente) REFERENCES cliente(codigo),
    FOREIGN KEY (cod_plano) REFERENCES plano(codigo),
    FOREIGN KEY (cod_servico) REFERENCES servico(codigo)
)

INSERT INTO plano 
VALUES
('100 Minutos', 80),
('150 Minutos', 130),
('200 Minutos', 160),
('250 Minutos', 220),
('300 Minutos', 260),
('600 Minutos', 350)

INSERT INTO servico 
VALUES
('100 SMS', 10),
('SMS Ilimitado', 30),
('Internet 500 MB', 40),
('Internet 1 GB', 60),
('Internet 2 GB', 70)

INSERT INTO cliente 
VALUES
(1234, 'Cliente A', '2012-10-15'),
(2468, 'Cliente B', '2012-11-20'),
(3702, 'Cliente C', '2012-11-25'),
(4936, 'Cliente D', '2012-12-01'),
(6170, 'Cliente E', '2012-12-18'),
(7404, 'Cliente F', '2013-01-20'),
(8638, 'Cliente G', '2013-01-25')

INSERT INTO contrato
VALUES
(1234, 3, 1, 'E', '2012-10-15'),
(1234, 3, 3, 'E', '2012-10-15'),
(1234, 3, 3, 'A', '2012-10-16'),
(1234, 3, 1, 'A', '2012-10-16'),
(2468, 4, 4, 'E', '2012-11-20'),
(2468, 4, 4, 'A', '2012-11-21'),
(6170, 6, 2, 'E', '2012-12-18'),
(6170, 6, 5, 'E', '2012-12-19'),
(6170, 6, 2, 'A', '2012-12-20'),
(6170, 6, 5, 'A', '2012-12-21'),
(1234, 3, 1, 'D', '2013-01-10'),
(1234, 3, 3, 'D', '2013-01-10'),
(1234, 2, 1, 'E', '2013-01-10'),
(1234, 2, 1, 'A', '2013-01-11'),
(2468, 4, 4, 'D', '2013-01-25'),
(7404, 2, 1, 'E', '2013-01-20'),
(7404, 2, 5, 'E', '2013-01-20'),
(7404, 2, 5, 'A', '2013-01-21'),
(7404, 2, 1, 'A', '2013-01-22'),
(8638, 6, 5, 'E', '2013-01-25'),
(8638, 6, 5, 'A', '2013-01-26'),
(7404, 2, 5, 'D', '2013-02-03')

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos cancelados, ordenados pelo nome do cliente	
SELECT  c.nome as cliente, p.nome as plano, COUNT(co.status) as qtn
FROM cliente c, plano p,contrato co
WHERE c.codigo = co.cod_cliente AND p.codigo = co.cod_plano AND co.status = 'D'
GROUP BY p.nome, c.nome
ORDER BY c.nome
-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos não cancelados, ordenados pelo nome do cliente	
SELECT  c.nome as cliente, p.nome as plano, COUNT(co.status) as qtn
FROM cliente c, plano p,contrato co
WHERE c.codigo = co.cod_cliente AND p.codigo = co.cod_plano AND co.status != 'D'
GROUP BY p.nome, c.nome
ORDER BY c.nome
-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada contrato que está ou esteve ativo, sob as seguintes condições:	
	-- A conta é o valor do plano, somado à soma dos valores de todos os serviços
	-- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%
	-- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%
	-- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%
	-- Contas com valor inferiores a R$200,00 não tem desconto
SELECT c.nome cliente, p.nome plano,
CASE
	WHEN p.valor + SUM(s.valor) > 400 THEN
	(p.valor + SUM(s.valor)) * 0.92
	WHEN p.valor + SUM(s.valor) > 300 THEN
	(p.valor + SUM(s.valor)) * 0.95
	WHEN p.valor + SUM(s.valor) > 200 THEN
	(p.valor + SUM(s.valor)) * 0.97
	ELSE
	p.valor + SUM(s.valor)
END conta
FROM cliente c, plano p,contrato co, servico s
WHERE c.codigo = co.cod_cliente AND co.cod_plano = p.codigo AND co.cod_servico = s.codigo AND co.status != 'D'
GROUP BY c.nome,p.nome, p.valor
-- Consultar o nome do cliente, o nome do serviço, e a duração, em meses (até a data de hoje) do serviço, dos cliente que nunca cancelaram nenhum plano	

SELECT c.nome cliente, s.nome servico, DATEDIFF(MONTH,co.data_contrato,GETDATE()) data
FROM cliente c, servico s, contrato co
WHERE co.cod_cliente = c.codigo AND co.cod_servico = s.codigo AND co.status != 'D'
