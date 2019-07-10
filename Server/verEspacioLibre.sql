-- sp que devuelve el espacio libre en MB, que tiene cada unidad (C,D,E,etc) donde se encuentra instalado el Sql Server.
--¿Querés conocer el espacio en disco disponible en tu servidor de base de datos?

exec master.dbo.xp_fixeddrives
