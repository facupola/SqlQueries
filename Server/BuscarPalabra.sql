-- Reemplazar la palabra Texto_a_Buscar por la palabra a buscar (ctrl+H)
-- Querés buscar que tablas tienen la columna 'xxx'? La vista que usa 'xxx'?

-- Busca en Vistas, funciones, etc
select text
from syscomments
where text like '%Texto_a_Buscar%'

select sysobjects.name, syscomments.text
from syscomments inner join sysobjects on syscomments.id = sysobjects.id
where (sysobjects.xtype = 'P' OR sysobjects.xtype = 'TR') and
syscomments.text like '%Texto_a_Buscar%'
order by sysobjects.name 

-- Busca Tablas que contengan el nombre de columna
SELECT TABLE_NAME,*
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Texto_a_Buscar%'

--Buscar en Stores procedures
SELECT Name 
    FROM sys.procedures 
    WHERE OBJECT_DEFINITION(object_id) LIKE '%Texto_a_Buscar%'

--Buscar Nombre de indice
select * from sys.indexes where name like '%Texto_a_Buscar%'
