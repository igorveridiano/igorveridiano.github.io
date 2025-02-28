use curso

--drop table produto
create table produto
   (cod nvarchar(5),
    nome nvarchar(20)
)


--Exemplo de Bulk Insert
BULK INSERT produto 
FROM 'D:\Git\CursoSqlServer\17_BULK\carga\produto.txt'
WITH        (
	codepage='ACP',  -- { 'ACP' | 'OEM' | 'RAW' | 'code_page' } ] 
    DATAFILETYPE = 'char',   --      { 'char' | 'native'| 'widechar' | 'widenative' } ]         
	fieldterminator='|',               
	rowterminator='\n',               
	maxerrors = 0,               
	fire_triggers,             
   firstrow = 3,               
 	lastrow = 10
	     ) ;

	--VERFICANDO DADOS IMPORTADOS
	select *  from produto
	--DELETANDO ARQUIVOS
	delete from produto


