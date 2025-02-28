--EXEMPLO MERGE
--CRIANDO TABELA TEMPORARIA 1
--DROP TABLE #Tabela1 
CREATE TABLE #Tabela1 
        ( 
		 nome VARCHAR (100),
         cadastro DATETIME,
		 alteracao DATETIME,
		 situacao BIT)

INSERT #Tabela1  VALUES 
			('JACK', GETDATE(), NULL, 1),
            ('PETER', GETDATE(), NULL, 1),
            ('JOHN', GETDATE(), NULL, 1),
            ('MALCON', GETDATE(), NULL, 1),
			('ARTHUR', GETDATE(), NULL, 1)
--DROP TABLE #Tabela2 
CREATE TABLE #Tabela2 
		( nome VARCHAR(100), 
		  email VARCHAR(100))

INSERT #Tabela2  VALUES 
			('JACK','jack@jack.com'),
            ('PETER','peter@peter.com'),
            ('JOHN','john@jonh.com'),
            ('MALCON','malcon@malcon.com'),
			('RICHARD','richard@richard.com')

SELECT * FROM #Tabela1

SELECT * FROM #Tabela2

--INICIO MERGE

MERGE #Tabela1 AS Destino

USING #Tabela2 AS Origem

ON Destino.Nome = Origem.Nome

-- Há registro no destino e na origem
WHEN MATCHED

THEN UPDATE SET situacao = 0, Alteracao = GETDATE()

--Quando não há registro no destino e há na origem
WHEN NOT MATCHED

THEN INSERT (Nome, Cadastro,alteracao,situacao) VALUES (origem.nome, Getdate(), Getdate(),1)

-- Quando  há registro no destino mas não há na origem

WHEN NOT MATCHED BY SOURCE 

THEN UPDATE SET situacao = NULL, alteracao = GETDATE();


--VERIFICANDO RESULTADO
SELECT * FROM #Tabela1

SELECT * FROM #Tabela2 