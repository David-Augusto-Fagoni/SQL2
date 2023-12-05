CREATE DATABASE mercadoria
GO
USE mercadoria
GO
CREATE TABLE cliente 
(
    codigo INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    telefone CHAR(13) NOT NULL,
    telefone_comercial CHAR(12) NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE tipo_mercadoria 
(
    codigo INT IDENTITY(10001, 1) NOT NULL,
    nome VARCHAR(50) NOT NULL
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE corredores 
(
    codigo INT IDENTITY(101, 1) NOT NULL,
    tipo INT NULL,
    nome VARCHAR(50) NULL
    PRIMARY KEY (codigo)
    FOREIGN KEY (tipo) REFERENCES tipo_mercadoria(codigo)
)
GO
CREATE TABLE mercadoria 
(
    codigo INT IDENTITY (1001, 1) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    corredor INT NOT NULL,
    tipo INT NOT NULL,
    valor DECIMAL(7, 2) NOT NULL
    PRIMARY KEY (codigo)
    FOREIGN KEY (corredor) REFERENCES corredores(codigo),
    FOREIGN KEY (tipo) REFERENCES tipo_mercadoria(codigo)
)
GO
CREATE TABLE compra 
(
    nota_fiscal INT NOT NULL,
    codigo_cliente INT NOT NULL,
    valor DECIMAL(7, 2) NOT NULL
    PRIMARY KEY (nota_fiscal)
    FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)

INSERT INTO cliente 
VALUES
('Luis Paulo', 'R. Xv de Novembro, 100', '45657878', NULL),
('Maria Fernanda', 'R. Anhaia, 1098', '27289098', '40040090'),
('Ana Claudia', 'Av. Volunt�rios da P�tria, 876', '21346548', NULL),
('Marcos Henrique', 'R. Pantojo, 76', '51425890', '30394540'),
('Emerson Souza', 'R. Pedro �lvares Cabral, 97', '44236545', '39389900'),
('Ricardo Santos', 'Trav. Hum, 10', '98789878', NULL)

INSERT INTO tipo_mercadoria 
VALUES
('P�es'),
('Frios'),
('Bolacha'),
('Clorados'),
('Frutas'),
('Esponjas'),
('Massas'),
('Molhos')

INSERT INTO corredores
VALUES
(10001, 'Padaria'),
(10002, 'Cal�ados'),
(10003, 'Biscoitos'),
(10004, 'Limpeza'),
(NULL, NULL),
(NULL, NULL),
(10007, 'Congelados')

INSERT INTO mercadoria
VALUES
('P�o de Forma', 101, 10001, 3.5),
('Presunto', 101, 10002, 2.0),
('Cream Cracker', 103, 10003, 4.5),
('�gua Sanit�ria', 104, 10004, 6.5),
('Ma��', 105, 10005, 0.9),
('Palha de A�o', 106, 10006, 1.3),
('Lasanha', 107, 10007, 9.7)

INSERT INTO compra 
VALUES
(1234, 2, 200),
(2345, 4, 156),
(3456, 6, 354),
(4567, 3, 19)

-- Valor da Compra de Luis Paulo
SELECT c.valor
FROM compra as c, cliente as cl
WHERE c.codigo_cliente = cl.codigo AND cl.nome LIKE 'Luis%'
-- Valor da Compra de Marcos Henrique
SELECT c.valor
FROM compra as c, cliente as cl
WHERE c.codigo_cliente = cl.codigo AND cl.nome LIKE 'Marcos%'
-- Endere�o e telefone do comprador de Nota Fiscal = 4567
SELECT cl.endereco, cl.telefone
FROM cliente as cl, compra as c
WHERE c.codigo_cliente = cl.codigo AND c.nota_fiscal = 4567
-- Valor da mercadoria cadastrada do tipo " P�es"
SELECT m.valor
FROM mercadoria as m, tipo_mercadoria as t
WHERE m.tipo = t.codigo AND t.nome LIKE 'P�es'
-- Nome do corredor onde est� a Lasanha
SELECT co.nome
FROM corredores as co, mercadoria as m
WHERE co.codigo = m.corredor AND m.nome LIKE 'lasanha'
-- Nome do corredor onde est�o os clorados
SELECT co.nome
FROM corredores as co, tipo_mercadoria as t
WHERE co.tipo = t.codigo AND t.nome LIKE 'clorados'