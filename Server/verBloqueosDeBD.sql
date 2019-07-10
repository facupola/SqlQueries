-- Consulta que permite conocer si hay procesos bloqueando la base de datos/tablas.
-- Cómo identificar un bloqueo en SQL Server? ( en caso de detectarse, analizar que lo esta provocando y ejecutar el comando kill para 'matar' el proceso

SET nocount ON 

DECLARE @blocker_spid    INT, 
        @blockee_spid    INT, 
        @blockee_blocker INT 
DECLARE @blockee_waitime INT 

IF EXISTS (SELECT * 
           FROM   master.dbo.sysprocesses 
           WHERE  spid IN (SELECT blocked 
                           FROM   master.dbo.sysprocesses)) 
  BEGIN 
      DECLARE blocker_cursor CURSOR FOR 
        SELECT spid 
        FROM   master.dbo.sysprocesses 
        WHERE  spid IN (SELECT blocked 
                        FROM   master.dbo.sysprocesses) 
               AND blocked = 0 
      DECLARE blockee_cursor CURSOR FOR 
        SELECT spid, 
               blocked, 
               waittime 
        FROM   master.dbo.sysprocesses 
        WHERE  blocked > 0 

      OPEN blocker_cursor 

      FETCH next FROM blocker_cursor INTO @blocker_spid 

      WHILE ( @@FETCH_STATUS = 0 ) 
        BEGIN 
            SELECT 'Spid Bloqueador: ', 
                   @blocker_spid 

            EXEC Sp_who 
              @blocker_spid 

            EXEC Sp_executesql 
              N'dbcc inputbuffer(@Param)', 
              N'@Param int', 
              @blocker_spid 

            --SELECT Blocked = spid FROM master.dbo.sysprocesses WHERE blocked = @blocker_spid  
            OPEN blockee_cursor 

            FETCH next FROM blockee_cursor INTO @blockee_spid, @blockee_blocker, 
            @blockee_waitime 

            WHILE ( @@fetch_status = 0 ) 
              BEGIN 
                  --SELECT Blocked = spid FROM master.dbo.sysprocesses WHERE blocked = @blocker_spid  
                  --Select 'EE: ', @blockee_blocker, ' Er: ',@blocker_spid  
                  IF ( @blockee_blocker = @blocker_spid ) 
                    BEGIN 
                        SELECT 'Blockee: Waittime:', 
                               @blockee_spid, 
                               @blockee_waitime 

                        EXEC Sp_executesql 
                          N'dbcc inputbuffer(@Param)', 
                          N'@Param int', 
                          @blockee_spid 
                    END 

                  FETCH next FROM blockee_cursor INTO @blockee_spid, 
                  @blockee_blocker, 
                  @blockee_waitime 
              END 

            CLOSE blockee_cursor 

            FETCH next FROM blocker_cursor INTO @blocker_spid 
        END 

      CLOSE blocker_cursor 

      DEALLOCATE blockee_cursor 

      DEALLOCATE blocker_cursor 
  --go  
  END 
ELSE 
  SELECT 'No hay procesos bloqueados!' AS Resultado 

go 
--KILL 79;  
