/*

drop  table t_funcionario
drop  table t_deptos
drop  table t_func_sal
drop  table t_bonus	
drop FUNCTION dbo.func_calc_bonus

*/

USE curso 

go 

CREATE TABLE t_funcionario 
  ( 
     id_func   INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, 
     nome_func VARCHAR(30) NOT NULL, 
     id_depto  INT NOT NULL 
  ) 

go 

CREATE TABLE t_deptos 
  ( 
     id_depto   INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, 
     nome_depto VARCHAR(30) 
  ) 

go 

CREATE TABLE t_func_sal 
  ( 
     id_func INT NOT NULL PRIMARY KEY, 
     valor   DECIMAL(10, 2) NOT NULL 
  ) 

go 

CREATE TABLE t_bonus 
  ( 
     id_func   INT NOT NULL PRIMARY KEY, 
     pct_bonus DECIMAL (10, 2) NOT NULL 
  ) 

--populando tabelas 
INSERT INTO t_deptos 
VALUES      ('Administracao'), 
            ('Producao') 

INSERT INTO t_funcionario 
VALUES      ('Will',1), ('John',1), 
            ('Peter',1),('Derek',2), 
            ('Greg',2), ('Mary',2), 
            ('Jane',1), ('Mark',2), 
            ('Samy',1), ('Saul',2) 

INSERT INTO t_func_sal 
VALUES      (1,1000),(2,1500), 
            (3,2000),(4,2500), 
            (5,3000),(6,3500), 
            (7,1250),(8,1750), 
            (9,2250),(10,3250) 

INSERT INTO t_bonus 
VALUES      (1,2),(3,2.5), 
            (5,1.75),(7,2.75), 
            (9,1.25) 

--VERIFICANDO DADOS
			SELECT * FROM   t_funcionario; 
			SELECT * FROM   t_deptos; 
			SELECT * FROM   t_func_sal; 
			SELECT * FROM   t_bonus; 

--Demonstrando inner , left join, left outer join 
SELECT a.id_func, 
       a.nome_func, 
       b.pct_bonus 
FROM   t_funcionario a 
       LEFT OUTER JOIN t_bonus b 
               ON a.id_func = b.id_func 

--CRIANDO DA FUNÇAO QUE CALCULA BONUS
CREATE FUNCTION dbo.func_calc_bonus (@p_id_func int)
RETURNS @tbl TABLE (
  val_bonus decimal(10, 2)
)
AS
BEGIN
  --TABELA ALVO
  INSERT INTO @tbl
    --SELECT PARA INSERT 	
    SELECT
      CAST(a.valor * (b.pct_bonus / 100) AS decimal(10, 2)) AS val_bonus
    FROM t_func_sal a
    INNER JOIN t_bonus b
      ON a.id_func = b.id_func
    WHERE a.id_func = @p_id_func
  RETURN
END;

--Invocando a função
SELECT *FROM dbo.func_calc_bonus(1)


--Usando CROSS APLY 
SELECT      a.id_func, 
            a.nome_func,
			c.nome_depto ,
            b.valor, 
           F_BON.val_bonus 
FROM        t_funcionario a 
INNER JOIN  t_func_sal b 
ON          a.id_func=b.id_func 
INNER JOIN  t_deptos c 
ON          a.id_depto=c.id_depto
CROSS apply dbo.Func_calc_bonus(a.id_func) AS F_BON; 

--Usando OUTER APLY
SELECT      a.id_func, 
            a.nome_func,
			c.nome_depto ,
            b.valor, 
             ISNULL(F_BON.val_bonus,0) val_bonus
FROM        t_funcionario a 
INNER JOIN  t_func_sal b 
ON          a.id_func=b.id_func 
INNER JOIN  t_deptos c 
ON          a.id_depto=c.id_depto
OUTER apply dbo.Func_calc_bonus(a.id_func) AS F_BON;