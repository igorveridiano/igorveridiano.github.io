/*
EXERC�CIO 1 
Crie o banco de dados treino com as tabelas conforme diagrama.
*/
CREATE DATABASE RESPOSTA
GO 
USE RESPOSTA

CREATE TABLE CIDADE
	(ID_CIDADE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CIDADE VARCHAR(60) NOT NULL,
	UF VARCHAR(2) NOT NULL)

CREATE TABLE VENDEDORES
	(ID_VENDEDOR INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_VENDE VARCHAR(60) NOT NULL,
	SALRIO DECIMAL(10,2) NOT NULL)

CREATE TABLE CATEGORIA
	(ID_CATEGORIA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CATEGORIA VARCHAR(20) NOT NULL)

CREATE TABLE UNIDADE
	(ID_UNIDADE VARCHAR(3) NOT NULL PRIMARY KEY,
	DESC_UNIDADE VARCHAR(25) NOT NULL)
	
CREATE TABLE CLIENTE
	(ID_CLIENTE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CLIENTE VARCHAR(60) NOT NULL,
	ENDERECO VARCHAR(60) NOT NULL,
	ID_CIDADE INT NOT NULL,
	CEP VARCHAR(9) NOT NULL,
	CONSTRAINT FK_CLCID1 FOREIGN KEY (ID_CIDADE) REFERENCES CIDADE(ID_CIDADE))

CREATE TABLE VENDAS
	(NUM_VEND INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	DATA_VEND SMALLDATETIME NOT NULL,
	ID_CLIENTE INT NOT NULL,
	ID_VENDED INT NOT NULL,
	STATUS CHAR(1) NOT NULL,
	CONSTRAINT FK_VDACLI1 FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
	CONSTRAINT FK_VDAVDO1 FOREIGN KEY (ID_VENDED) REFERENCES VENDEDORES(ID_VENDEDOR))

CREATE TABLE PRODUTOS
	(ID_PROD INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_PROD VARCHAR(50) NOT NULL,
	ID_CATEGORIA INT NOT NULL,
	ID_UNIDADE VARCHAR(3) NOT NULL,
	PRECO DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_PRODCAT1 FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA(ID_CATEGORIA),
	CONSTRAINT FK_PRODUNI1 FOREIGN KEY (ID_UNIDADE) REFERENCES UNIDADE(ID_UNIDADE))

CREATE TABLE VENDA_ITENS
	(NUM_VEN INT NOT NULL,
	NUM_SE INT IDENTITY(1,1) NOT NULL,
	ID_PROD INT NOT NULL,
	QTDE DECIMAL(10,2) NOT NULL,
	VAL_UNIT DECIMAL(10,2) NOT NULL,
	VAL_TOTAL DECIMAL(10,2),
	CONSTRAINT PK_VENITEN1 PRIMARY KEY (NUM_VEN, NUM_SE),
	CONSTRAINT FK_VNITVEND1 FOREIGN KEY (NUM_VEN) REFERENCES VENDAS(NUM_VEND),
	CONSTRAINT FK_VNITPROD1 FOREIGN KEY (ID_PROD) REFERENCES PRODUTOS(ID_PROD))

/*
EXERC�CIO 2 
Restaurar o arquivo  treino.bak no banco de dados criado.
*/

/*
EXERC�CIO 3 
Liste todos os clientes com seus nomes e com suas respectivas cidade e estados
*/

SELECT C.NOME_CLIENTE, CE.NOME_CIDADE, CE.UF FROM TREINO..CLIENTE C INNER JOIN TREINO..CIDADE CE ON C.ID_CIDADE = CE.ID_CIDADE
  
/*
EXERC�CIO 4 
Liste o c�digo do produto, descri��o do produto e descri��o das categorias dos produtos que tenham o valor unit�rio na 
faixa de R$ 10,00 a R$ 1500
*/

SELECT P.ID_PROD, P.NOME_PRODUTO, C.NOME_CATEGORIA FROM TREINO..PRODUTOS P INNER JOIN TREINO..CATEGORIA C ON P.ID_CATEGORIA = C.ID_CATEGORIA WHERE P.PRECO >= 10 AND P.PRECO <= 1500

/*
EXERC�CIO 5 
Liste o c�digo do produto, descri��o do produto e descri��o da categorias dos produtos, e tamb�m apresente uma coluna condicional  com o  nome de "faixa de pre�o" 
Com os seguintes crit�rios
�	pre�o< 500 : valor da coluna ser�  igual  "pre�o abaixo de 500"
�	pre�o  >= 500 e <=1000 valor da coluna ser� igual  "pre�o entre 500 e 1000"
�	pre�o  > 1000 : valor da coluna ser� igual  "pre�o acima de 1000".
*/

SELECT 
	P.ID_PROD, P.NOME_PRODUTO, C.NOME_CATEGORIA,
	CASE WHEN P.PRECO < 500 THEN 'Pre�o abaixo de 500'
	ELSE CASE WHEN P.PRECO >= 500 AND P.PRECO <= 1000 THEN 'Pre�o entre 500 e 1000'
	ELSE CASE WHEN P.PRECO > 1000 THEN 'Pre�o acima de 1000' END END END AS 'FAIXA DE PRE�O'
FROM 
	TREINO..PRODUTOS P INNER JOIN TREINO..CATEGORIA C ON P.ID_CATEGORIA = C.ID_CATEGORIA

/*
EXERC�CIO  6
Adicione a coluna faixa_salario na tabela vendedor tipo char(1)
*/

ALTER TABLE RESPOSTA..VENDEDORES ADD FAIXA_SALARIO CHAR(1) NULL
ALTER TABLE TREINO..VENDEDORES ADD FAIXA_SALARIO CHAR(1) NULL 

/*
EXERC�CIO 7 
Atualize o valor do campo faixa_salario da tabela vendedor com um update condicional .
Com os seguintes crit�rios
�	salario <1000 ,atualizar faixa = c
�	salario >=1000  and <2000 , atualizar faixa = b
�	salario >=2000  , atualizar faixa = a

**VERIFIQUE SE OS VALORES FORAM ATUALIZADOS CORRETAMENTE
*/

UPDATE TREINO..VENDEDORES 
	SET FAIXA_SALARIO = CASE WHEN SALARIO < 1000 THEN 'C'
						WHEN SALARIO >= 1000 AND SALARIO < 2000 THEN 'B'
						WHEN SALARIO >= 2000 THEN 'A' END
/*
EXERC�CIO 8
Listar em ordem alfab�tica os vendedores e seus respectivos sal�rios, mais uma coluna, simulando aumento de 12% em seus sal�rios.
*/

SELECT V.NOME_VENDEDOR, V.SALARIO, CONVERT(DECIMAL(10,2),(V.SALARIO * 0.12 + V.SALARIO))AS 'SALARIO COM AUMENTO DE 12%' FROM TREINO..VENDEDORES V ORDER BY V.NOME_VENDEDOR

/*EXERC�CIO 9
Listar os nome dos vendedores, sal�rio atual , coluna calculada com salario novo + reajuste de 18% sobre o sal�rio atual, calcular  a coluna acr�scimo e calcula uma coluna salario novo+ acresc.
Crit�rios
Se o vendedor for  da faixa �C�, aplicar  R$ 120 de acr�scimo , outras faixas de salario acr�scimo igual a 0(Zero )
*/

SELECT 
	V.NOME_VENDEDOR, V.SALARIO, 
	CONVERT(DECIMAL(10,2),(V.SALARIO * 0.12 + V.SALARIO) + (V.SALARIO * 0.18)) AS 'SALARIO NOVO COM REAJUSTE DE 18%',
	CONVERT(DECIMAL(10,2),CASE WHEN V.FAIXA_SALARIO = 'C' THEN 120 ELSE 0 END) AS 'ACR�SCIMO',
	CONVERT(DECIMAL(10,2),(V.SALARIO * 0.12 + V.SALARIO) + (CASE WHEN V.FAIXA_SALARIO = 'C' THEN 120 ELSE 0 END)) AS 'SALARIO NOVO MAIS ACR�SCIMO'
FROM TREINO..VENDEDORES V

/*
EXERC�CIO 10
Listar o nome e sal�rios do vendedor com menor salario.
*/

SELECT V.NOME_VENDEDOR, V.SALARIO FROM TREINO..VENDEDORES V WHERE V.SALARIO = (SELECT MIN(V2.SALARIO) FROM TREINO..VENDEDORES V2)

/*
EXERC�CIO 11
Quantos vendedores ganham acima de R$ 2.000,00 de sal�rio fixo?
*/

SELECT COUNT(ID_VENDEDOR) AS 'VENDEDORES QUE GANHAM MAIS DE 2000' FROM TREINO..VENDEDORES WHERE SALARIO > 2000

/*
EXERC�CIO 12
Adicione o campo valor_total tipo decimal(10,2) na tabela venda.
*/

ALTER TABLE RESPOSTA..VENDAS ADD VALOR_TOTAL DECIMAL(10, 2)
ALTER TABLE TREINO..VENDAS ADD VALOR_TOTAL DECIMAL(10, 2)

/*
EXERC�CIO 13
Atualize o campo valor_tota da tabela venda, com a soma dos produtos das respectivas vendas.
*/

;WITH VALORES
AS
(
SELECT 
	V.NUM_VENDA, SUM(VI.VAL_TOTAL) AS VALOR
FROM 
	TREINO..VENDAS V INNER JOIN TREINO..VENDA_ITENS VI ON V.NUM_VENDA = VI.NUM_VENDA
GROUP BY
	V.NUM_VENDA
)
UPDATE V
	SET V.VALOR_TOTAL = VALORES.VALOR
FROM 
	TREINO..VENDAS V  INNER JOIN VALORES ON V.NUM_VENDA = VALORES.NUM_VENDA


/*
EXERC�CIO 14
Realize a conferencia do exerc�cio anterior, certifique-se que o valor  total de cada venda e igual ao valor total da soma dos  produtos da venda, listar as vendas em que ocorrer diferen�a.
*/
SELECT
	V1.*
FROM 
	TREINO..VENDAS V1
WHERE 
	V1.VALOR_TOTAL <> (SELECT SUM(VI.VAL_TOTAL)
					  FROM 
						TREINO..VENDAS V2 INNER JOIN TREINO..VENDA_ITENS VI ON V2.NUM_VENDA = VI.NUM_VENDA
					  WHERE 
						V2.NUM_VENDA = V1.NUM_VENDA
					  GROUP BY
						V2.NUM_VENDA)
/*
EXERC�CIO 15
Listar o n�mero de produtos existentes, valor total , m�dia do valor unit�rio referente ao m�s 07/2018 agrupado por venda.
*/

SELECT 
	V.NUM_VENDA, V.VALOR_TOTAL, COUNT(VI.ID_PROD) 'QUANTIDADE DE PRODUTOS EXISTENTES', CONVERT(DECIMAL(10,2), (V.VALOR_TOTAL / (SUM(VI.QTDE)))) AS 'VALOR UNIT�RIO M�DIO' 
FROM 
	TREINO..VENDA_ITENS VI  INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
WHERE
	V.DATA_VENDA >= '2018-07-01' AND V.DATA_VENDA <= '2018-07-31' 
GROUP BY
	V.NUM_VENDA, V.VALOR_TOTAL
	
/*
EXERC�CIO 16
Listar o n�mero de vendas, Valor do ticket m�dio, menor ticket e maior ticket referente ao m�s 07/2017.
*/

SELECT 
	COUNT(V.NUM_VENDA) AS 'N�MERO DE VENDAS', CONVERT(DECIMAL(10,2),ROUND((SUM(V.VALOR_TOTAL) / COUNT(V.NUM_VENDA)),2)) AS 'TICKET M�DIO', MIN(V.VALOR_TOTAL) AS 'MENOR TICKET', MAX(V.VALOR_TOTAL) AS 'MAIOR TICKET'
FROM 
	TREINO..VENDAS V INNER JOIN TREINO..VENDA_ITENS VI ON V.NUM_VENDA = VI.NUM_VENDA
WHERE 
	V.DATA_VENDA >= '2017-07-01' AND V.DATA_VENDA <= '2017-07-31' 

/*
EXERC�CIO 17
Atualize o status das notas abaixo de normal(N) para cancelada (C)
--15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714

*/

UPDATE TREINO..VENDAS SET STATUS = 'C' WHERE NUM_VENDA IN (15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714)

/*
EXERC�CIO 18
Quais clientes realizaram mais de 70 compras?
*/

SELECT 
	C.ID_CLIENTE, C.NOME_CLIENTE
FROM 
	TREINO..CLIENTE C INNER JOIN TREINO..VENDAS V ON C.ID_CLIENTE = V.ID_CLIENTE
GROUP BY
	C.ID_CLIENTE, C.NOME_CLIENTE
HAVING 
	COUNT(V.NUM_VENDA) > 70

/*
EXERC�CIO 19
Listar os produtos que est�o inclu�dos em vendas que a quantidade total de produtos seja superior a 100 unidades.
*/

SELECT 
	P.ID_PROD, P.NOME_PRODUTO 
FROM 
	TREINO..PRODUTOS P INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
GROUP BY
	P.ID_PROD, P.NOME_PRODUTO 
HAVING
	SUM(VI.QTDE) > 100

/*
EXERC�CIO 20
Trazer total de vendas do ano 2017 por categoria e apresentar total geral
*/

SELECT
	C.ID_CATEGORIA, C.NOME_CATEGORIA, COUNT(V.NUM_VENDA) 'TOTAL DE VENDAS', (SELECT COUNT(V.NUM_VENDA) FROM TREINO..VENDAS V) 'TOTAL GERAL'
FROM	
	TREINO..CATEGORIA C INNER JOIN TREINO..PRODUTOS P ON C.ID_CATEGORIA = P.ID_CATEGORIA
	INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
WHERE
	YEAR(V.DATA_VENDA) = '2017' 
GROUP BY 
	C.ID_CATEGORIA, C.NOME_CATEGORIA

/*
EXERC�CIO 21
Listar total de vendas do ano 2017 por categoria e m�s a m�s apresentar subtotal dos meses e total geral ano.
*/

SELECT
	C.ID_CATEGORIA, C.NOME_CATEGORIA, MONTH(V.DATA_VENDA) AS 'M�S', COUNT(V.NUM_VENDA) 'TOTAL DE VENDAS', (SELECT COUNT(V.NUM_VENDA) FROM TREINO..VENDAS V) 'TOTAL GERAL'
FROM	
	TREINO..CATEGORIA C INNER JOIN TREINO..PRODUTOS P ON C.ID_CATEGORIA = P.ID_CATEGORIA
	INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
WHERE
	YEAR(V.DATA_VENDA) = '2017' 
GROUP BY 
	C.ID_CATEGORIA, C.NOME_CATEGORIA, MONTH(V.DATA_VENDA)

/*
EXERC�CIO 22
Listar total de vendas por vendedores referente ao ano 2017, m�s a m�s apresentar subtotal do m�s e total geral.
*/

SELECT
	VE.ID_VENDEDOR, VE.NOME_VENDEDOR, MONTH(V.DATA_VENDA) AS 'M�S', COUNT(V.NUM_VENDA) 'TOTAL DE VENDAS', (SELECT COUNT(V.NUM_VENDA) FROM TREINO..VENDAS V) 'TOTAL GERAL'
FROM	
	TREINO..VENDEDORES VE INNER JOIN TREINO..VENDAS V ON VE.ID_VENDEDOR = V.ID_VENDEDOR
WHERE
	YEAR(V.DATA_VENDA) = '2017' 
GROUP BY 
	VE.ID_VENDEDOR, VE.NOME_VENDEDOR, MONTH(V.DATA_VENDA)

/*
EXERC�CIO 23
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias
*/

SELECT 
	TOP 10 P.ID_PROD, P.NOME_PRODUTO, C.NOME_CATEGORIA, SUM(VI.QTDE) AS 'TOTAL DE VENDAS'
FROM 
	TREINO..CATEGORIA C INNER JOIN TREINO..PRODUTOS P ON C.ID_CATEGORIA = P.ID_CATEGORIA
	INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
GROUP BY
	P.ID_PROD, P.NOME_PRODUTO, C.NOME_CATEGORIA
ORDER BY 
	'TOTAL DE VENDAS' DESC
/*
EXERC�CIO 24
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias, calcular seu percentual de participa��o com rela��o ao total geral.
*/

SELECT 
	TOP 10 P.ID_PROD, P.NOME_PRODUTO, C.NOME_CATEGORIA, SUM(VI.QTDE) AS 'TOTAL DE VENDAS', 
	CONVERT(VARCHAR(10),CONVERT(DECIMAL(10,2),ROUND(((SUM(VI.QTDE) * 100) / (SELECT SUM(VI2.QTDE) FROM TREINO..VENDA_ITENS VI2)),2))) + '%' AS 'PERCENTUAL DE PARTICIPA��O'
FROM 
	TREINO..CATEGORIA C INNER JOIN TREINO..PRODUTOS P ON C.ID_CATEGORIA = P.ID_CATEGORIA
	INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
GROUP BY
	P.ID_PROD, P.NOME_PRODUTO, C.NOME_CATEGORIA
ORDER BY 
	'TOTAL DE VENDAS' DESC

/*
EXERC�CIO 25
Listar apenas o produto mais vendido de cada M�s com seu  valor total referente ao ano de 2017.
*/

SELECT 
	 P.ID_PROD, P.NOME_PRODUTO, MONTH(V.DATA_VENDA) AS 'M�S', SUM(VI.QTDE) AS 'TOTAL DE VENDAS'
FROM 
	TREINO..PRODUTOS P INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD 
	INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
WHERE
	YEAR(V.DATA_VENDA) = '2017'
GROUP BY
	P.ID_PROD, P.NOME_PRODUTO, MONTH(V.DATA_VENDA)
HAVING 
	SUM(VI.QTDE) = (SELECT TOP 1
						SUM(VI2.QTDE) AS 'TOTAL DE VENDAS'
					 FROM 
						TREINO..PRODUTOS P2 INNER JOIN TREINO..VENDA_ITENS VI2 ON P2.ID_PROD = VI2.ID_PROD 
						INNER JOIN TREINO..VENDAS V2 ON VI2.NUM_VENDA = V2.NUM_VENDA
					WHERE 
						YEAR(V2.DATA_VENDA) = '2017' AND
						MONTH(V2.DATA_VENDA) = MONTH(V.DATA_VENDA)
					GROUP BY
						P2.ID_PROD, P2.NOME_PRODUTO, MONTH(V2.DATA_VENDA)
					ORDER BY 
						'TOTAL DE VENDAS' DESC)
ORDER BY 
	 'M�S'

/*
EXERC�CIO 26
Lista o cliente e a data da �ltima compra de cada cliente.
*/

SELECT
	C.ID_CLIENTE, C.NOME_CLIENTE, MAX(V.DATA_VENDA) AS 'DATA ULTIMA COMPRA'
FROM	
	TREINO..CLIENTE C INNER JOIN TREINO..VENDAS V ON C.ID_CLIENTE = V.ID_CLIENTE
GROUP BY
	C.ID_CLIENTE, C.NOME_CLIENTE

/*
EXERC�CIO 27
Lista o a data da �ltima venda de cada produto.
*/

SELECT
	P.ID_PROD, P.NOME_PRODUTO, MAX(V.DATA_VENDA) AS 'DATA ULTIMA VENDA'
FROM	
	TREINO..PRODUTOS P INNER JOIN TREINO..VENDA_ITENS VI ON P.ID_PROD = VI.ID_PROD
	INNER JOIN TREINO..VENDAS V ON VI.NUM_VENDA = V.NUM_VENDA
GROUP BY
	P.ID_PROD, P.NOME_PRODUTO
