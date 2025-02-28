--VERIFICANDO SE EXISTE LINKED SERVER NO BD
SELECT * FROM   sys.servers


--CRIANDO LINKED SERVER
EXEC        sp_addlinkedserver 
            @server = 'LNK_EXP', 
			@srvproduct='', 
			@provider='SQLNCLI', 
			@datasrc='INFINITY\SQLEXPRESS' 

--CRIANDO USUARIO DO  LINKED SERVER

EXEC       sp_addlinkedsrvlogin
		    @rmtsrvname='LNK_EXP', 
			@useself='true', 
			@locallogin='INFINITY\andre', 
			@rmtuser=NULL, 
            @rmtpassword='derek1977'




EXEC sp_droplinkedsrvlogin @rmtsrvname='LNK_EXP',
                           @locallogin='INFINITY\andre'

--EXCLUINDO LINKED SERVER

EXEC sp_dropserver @server=N'LNK_EXP', @droplogins='droplogins'

--UTILIZANDO OPENQUERY
--SELECT 
SELECT * FROM OPENQUERY  (LNK_EXP,'SELECT * FROM curso.dbo.carros');


--INSERT 
INSERT   OPENQUERY  (LNK_EXP,'SELECT COD,NOME_CARRO,PRECO FROM curso.dbo.carros')
                 VALUES (4,'CARRO PRATA',35000);

--UPDATE 
UPDATE   OPENQUERY  (LNK_EXP,'SELECT COD,NOME_CARRO,PRECO FROM curso.dbo.carros WHERE COD=4')
                      SET PRECO=50000;

--DELETE 
DELETE   OPENQUERY  (LNK_EXP,'SELECT COD FROM curso.dbo.carros WHERE COD=''4''');
					 


--OUTRA FORMAS DE ACESSO
--SELECIONANDO DADOS ATRAVES DO LINKED SERVER
SELECT * FROM   LNK_EXP.curso.dbo.carros

---ATUALIZADO DADOS ATRAVES DO LINKED SERVER
UPDATE LNK_EXP.curso.dbo.carros SET NOME_CARRO='CARRO AMARELO'
WHERE cod=4

---INSERINDO DADOS ATRAVES DO LINKED SERVER
INSERT INTO LNK_EXP.curso.dbo.carros (COD,NOME_CARRO,PRECO) VALUES (5,'CARRO PRATA',35000)

--SELECIONANDO DADOS ATRAVES DO LINKED SERVER
SELECT * FROM   LNK_EXP.curso.dbo.carros

--EXCLUINDO USUARIO LINKED SERVER

