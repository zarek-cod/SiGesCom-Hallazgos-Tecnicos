/*
  Restauracion reproducible de SiGesCom.
  - No usa REPLACE.
  - Se niega a continuar si la base de destino ya existe.
  - Ajustar las rutas de datos si la instancia no es MSSQL17.SQLEXPRESS.
*/

USE [master];
GO

IF DB_ID(N'SiGesComV1_Libreria_Rossmary') IS NOT NULL
    THROW 51000, 'La base de destino ya existe; no se sobrescribio.', 1;
GO

RESTORE VERIFYONLY
FROM DISK = N'C:\SiGesCom\BaseDatos\SiGesComV1_Libreria_Rossmary.bak';
GO

RESTORE DATABASE [SiGesComV1_Libreria_Rossmary]
FROM DISK = N'C:\SiGesCom\BaseDatos\SiGesComV1_Libreria_Rossmary.bak'
WITH
    MOVE N'SiGesComV1' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\SiGesComV1_Libreria_Rossmary.mdf',
    MOVE N'SiGesComV1_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\SiGesComV1_Libreria_Rossmary_log.ldf',
    RECOVERY,
    STATS = 10;
GO

DBCC CHECKDB(N'SiGesComV1_Libreria_Rossmary') WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO

