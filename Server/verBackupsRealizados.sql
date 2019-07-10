-- Ver detalles de los Backups realizados sobre una base de datos o de TODAS. 
-- Cuando o donde se realizó el último backup? Nota: Reemplazar NombreBASEdeDatos

USE NombreBASEdeDatos 
go 

SELECT TOP 100 s.database_name, 
               m.physical_device_name, 
               Cast(Cast(s.backup_size / 1000000 AS INT) AS VARCHAR(14)) 
               + ' ' + 'MB'                     AS bkSize, 
               Cast(Datediff(second, s.backup_start_date, s.backup_finish_date) 
               AS VARCHAR(4)) 
               + ' ' + 'Seconds'                TimeTaken, 
               s.backup_start_date, 
               Cast(s.first_lsn AS VARCHAR(50)) AS first_lsn, 
               Cast(s.last_lsn AS VARCHAR(50))  AS last_lsn, 
               CASE s.[type] 
                 WHEN 'D' THEN 'Full' 
                 WHEN 'I' THEN 'Differential' 
                 WHEN 'L' THEN 'Transaction Log' 
               END                              AS BackupType, 
               s.server_name, 
               s.recovery_model 
FROM   msdb.dbo.backupset s 
       INNER JOIN msdb.dbo.backupmediafamily m 
               ON s.media_set_id = m.media_set_id 
WHERE  s.database_name = Db_name() -- Eliminar esta línea para ver de todas las base de datos
ORDER  BY backup_start_date DESC, 
          backup_finish_date 

go 
