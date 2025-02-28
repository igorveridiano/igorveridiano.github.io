--configurar ad hoc distribuida
sp_configure 'show advanced options', 1;  
RECONFIGURE;
GO 
sp_configure 'Ad Hoc Distributed Queries', 1;  
RECONFIGURE;  
GO 
--Para desativar, utilizamos as mesmas instruções, trocando “1” por “0”.

SELECT *  
FROM OPENROWSET('SQLNCLI', 'Server=infinity\sqlexpress;Trusted_Connection=yes;',  
     'SELECT *   
      FROM curso.dbo.carros') AS tabela_externa;

--INSERT 
INSERT OPENROWSET('SQLNCLI', 'Server=infinity\sqlexpress;Trusted_Connection=yes;',  
     'SELECT *   
      FROM curso.dbo.carros') 
VALUES (4,'CARRO METALICO',23000);

--UPDATE 
UPDATE OPENROWSET('SQLNCLI', 'Server=infinity\sqlexpress;Trusted_Connection=yes;',  
     'SELECT *   
      FROM curso.dbo.carros WHERE COD=4') 
SET PRECO=25000;

--UPDATE 
DELETE OPENROWSET('SQLNCLI', 'Server=infinity\sqlexpress;Trusted_Connection=yes;',  
     'SELECT *   
      FROM curso.dbo.carros WHERE COD=4') 



