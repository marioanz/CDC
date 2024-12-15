/****** Object:  Database CDCCube    Script Date: 9/06/2012 2:56:01 PM ******/
/*
Technology Solutions 5280, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4



Uncomment the next lines if you want to drop and create the database
*/
USE master;
GO
IF EXISTS (SELECT * FROM dbo.sysdatabases WHERE dbid = OBJECT_ID(N'CDCCube') AND OBJECTPROPERTY(dbid, N'IsDatabase') = 1)
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'CDCCube'
GO
USE master
GO
ALTER DATABASE [CDCCube] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE master
GO
DROP DATABASE CDCCube
GO
;
CREATE DATABASE CDCCube
GO
ALTER DATABASE CDCCube
SET RECOVERY SIMPLE
GO

USE CDCCube
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'OLAP Cube from AS400 VIP dB.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA Cube
GO


/* Drop table dbo.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimDate 
;

/* Create table dbo.DimDate */
CREATE TABLE dbo.DimDate (
   [DateKey]  int   NOT NULL
,  [FullDate]  date   NULL
,  [DateName]  varchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayNameOfWeek]  varchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekdayWeekend]  varchar(10)   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  varchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [IsLastDayOfMonth]  varchar(1)   NOT NULL
,  [CalendarQuarter]  tinyint   NOT NULL
,  [CalendarYear]  smallint   NOT NULL
,  [CalendarYearMonth]  varchar(10)   NOT NULL
,  [CalendarYearQtr]  varchar(10)   NOT NULL
,  [CalendarYearWeek] varchar(10)  NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;



/* Drop table dbo.DimAudit */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimAudit') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimAudit 
;

/* Create table dbo.DimAudit */
CREATE TABLE dbo.DimAudit (
   [AuditKey]  int IDENTITY  NOT NULL
,  [ParentAuditKey]  int   NOT NULL
,  [TableName]  nvarchar(50)  DEFAULT 'Unknown' NOT NULL
,  [PkgName]  nvarchar(50)  DEFAULT 'Unknown' NOT NULL
,  [PkgGUID]  uniqueidentifier   NULL
,  [PkgVersionGUID]  uniqueidentifier   NULL
,  [PkgVersionMajor]  smallint   NULL
,  [PkgVersionMinor]  smallint   NULL
,  [ExecStartDT]  datetime  DEFAULT getdate() NOT NULL
,  [ExecStopDT]  datetime   NULL
,  [ExecutionInstanceGUID]  uniqueidentifier   NULL
,  [ExtractRowCnt]  bigint   NULL
,  [InsertRowCnt]  bigint   NULL
,  [UpdateRowCnt]  bigint   NULL
,  [ErrorRowCnt]  bigint   NULL
,  [TableInitialRowCnt]  bigint   NULL
,  [TableFinalRowCnt]  bigint   NULL
,  [TableMaxSurrogateKey]  bigint   NULL
,  [SuccessfulProcessingInd]  nchar(1)  DEFAULT 'N' NOT NULL
, CONSTRAINT [PK_dbo.DimAudit] PRIMARY KEY CLUSTERED 
( [AuditKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Audit', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimAudit
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Audit', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimAudit
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Audit dimension tags each data row with the the process that added or updated it.', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimAudit
;

SET IDENTITY_INSERT dbo.DimAudit ON
;
INSERT INTO dbo.DimAudit (AuditKey, ParentAuditKey, TableName, PkgName, PkgGUID, PkgVersionGUID, PkgVersionMajor, PkgVersionMinor, ExecStartDT, ExecStopDT, ExecutionInstanceGUID, ExtractRowCnt, InsertRowCnt, UpdateRowCnt, ErrorRowCnt, TableInitialRowCnt, TableFinalRowCnt, TableMaxSurrogateKey, SuccessfulProcessingInd)
VALUES (-1, -1, 'Audit', 'None: Dummy row', NULL, NULL, NULL, NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y')
;
SET IDENTITY_INSERT dbo.DimAudit OFF
;

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'AuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'AuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ParentAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ParentAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TableName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgGUID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgGUID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgVersionGUID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgVersionGUID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgVersionMajor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgVersionMajor'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'PkgVersionMinor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgVersionMinor'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecStartDT', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExecStartDT'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecStopDT', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExecStopDT'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExecutionInstanceGUID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExecutionInstanceGUID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExtractRowCnt', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExtractRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertRowCnt', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'InsertRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateRowCnt', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'UpdateRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ErrorRowCnt', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ErrorRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TableInitialRowCnt', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableInitialRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TableFinalRowCnt', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableFinalRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TableMaxSurrogateKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableMaxSurrogateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SuccessfulProcessingInd', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'SuccessfulProcessingInd'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'AuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Foreign key to self, to identify calling package execution', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ParentAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the main table loaded by this package', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the SSIS package', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Identifier for the package', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgGUID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Identifier for the package version', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgVersionGUID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Major version number for the package', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgVersionMajor'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Minor version number for the package', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'PkgVersionMinor'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Date-time the package started executing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExecStartDT'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Date-time the package finished executing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExecStopDT'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Identifier for the execution of the package', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExecutionInstanceGUID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Count of rows extracted from the source(s)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ExtractRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Count of rows inserted in the destination table', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'InsertRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Count of rows updated in the destination table', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'UpdateRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Count of error rows', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ErrorRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Count of rows in target table before we begin', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableInitialRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Count of rows in target table after package ends', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableFinalRowCnt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Maximum surrogate key value in table (if we''re maintaining ourselves)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'TableMaxSurrogateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Did the package finish executing successfully?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'SuccessfulProcessingInd'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'AuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ParentAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'SuccessfulProcessingInd'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'AuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAudit', @level2type=N'COLUMN', @level2name=N'ParentAuditKey'; 
;



/* Drop table dbo.DimAccount */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimAccount') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimAccount 
;

/* Create table dbo.DimAccount */
CREATE TABLE dbo.DimAccount (
   [AccountKey]  smallint IDENTITY  NOT NULL
,  [AccountID]  char(5)  DEFAULT '00000' NOT NULL
,  [Account]  varchar(25)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [Premise]  varchar(11)  DEFAULT 'UNKNOWN' NOT NULL
,  [DeleteCode]  bit  DEFAULT 0 NOT NULL
,  [Latitude]  numeric(13,0) DEFAULT 0 NOT NULL
,  [Longitude]  numeric(13,0) DEFAULT 0 NOT NULL
,  [AccountGeo]  geography DEFAULT 'POINT(0 0)' NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimAccount] PRIMARY KEY CLUSTERED 
( [AccountKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimAccount
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ACCOUNT', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimAccount
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Account', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimAccount
;

SET IDENTITY_INSERT dbo.DimAccount ON
;

SET IDENTITY_INSERT dbo.DimAccount ON
;
INSERT INTO dbo.DimAccount (AccountKey, AccountID, Account, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00000', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, '12547', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-3, '13251', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-4, '15222', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-5, '16664', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-6, '18139', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-7, '18836', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-8, '20343', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-9, '21859', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-10, '28228', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-11, '30113', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-12, '30144', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimAccount OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[ACCOUNT]'))
DROP VIEW [Cube].[ACCOUNT]
GO
CREATE VIEW [Cube].[ACCOUNT] AS 
SELECT [AccountKey] AS [Account Key]
, [AccountID] AS [Account ID]
, [Account] AS [Account]
, [Active] AS [Active]
, [Premise] AS [On Off Premise]
, [DeleteCode] AS [Delete Code]
, [Latitude] AS [Latitude]
, [Longitude] AS [Longitude]
, [AccountGeo] AS [AccountGeo]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimAccount
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Account Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Account ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Account', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'On Off Premise', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Delete Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Account ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Account', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'On, Off, Both Premise', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Delete Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'12039, DR042', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'PHO NOODLE HOUSE', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'ON PREMISE, OFF PREMISE, BOTH', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'AccountNumber From AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'DBA_Name From AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From  AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'OnOffBoth_ID60 From AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'DeleteCode From AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'"', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'AccountBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'DBA_Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'OnOffBoth_ID60', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'DeleteCode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'AccountID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(25)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Account'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'numeric(1,0)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'Premise'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(1)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimAccount', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimArea */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimArea') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimArea 
;

/* Create table dbo.DimArea */
CREATE TABLE dbo.DimArea (
   [AreaKey]  smallint IDENTITY  NOT NULL
,  [AreaID]  char(2)  DEFAULT '00' NOT NULL
,  [Area]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimArea] PRIMARY KEY CLUSTERED 
( [AreaKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimArea
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'AREA', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimArea
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Route', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimArea
;

SET IDENTITY_INSERT dbo.DimArea ON
;
INSERT INTO dbo.DimArea (AreaKey, AreaID, Area, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES (-1, '00', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimArea OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[AREA]'))
DROP VIEW [Cube].[AREA]
GO
CREATE VIEW [Cube].[AREA] AS 
SELECT [AreaKey] AS [Area Key]
, [AreaID] AS [Area ID]
, [Area] AS [Area]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimArea
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Area Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Area ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Area', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Area ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Area Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, 27, 45', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'ARP, STAPLETON', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'AreaID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Area'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimArea', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimBrand */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimBrand') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimBrand 
;

/* Create table dbo.DimBrand */
CREATE TABLE dbo.DimBrand (
   [BrandKey]  smallint IDENTITY  NOT NULL
,  [BrandID]  char(2)  DEFAULT '00' NOT NULL
,  [Brand]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Brewer]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimBrand] PRIMARY KEY CLUSTERED 
( [BrandKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrand
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BRAND', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrand
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Beer Brands', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrand
;

SET IDENTITY_INSERT dbo.DimBrand ON
;
INSERT INTO dbo.DimBrand (BrandKey, BrandID, Brand, Brewer, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00', 'UNKNOWN', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, 'UK', 'MISSING', 'MISSING', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimBrand OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[BRAND]'))
DROP VIEW [Cube].[BRAND]
GO
CREATE VIEW [Cube].[BRAND] AS 
SELECT [BrandKey] AS [Brand Key]
, [BrandID] AS [Brand ID]
, [Brand] AS [Brand]
, [Brewer] AS [Brewer]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimBrand
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business Key from BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Beer Family Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'BrewerID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'TK, 95, G6', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'MILLERCOORS', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, DQ, MB, C2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(2)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'BrandID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(2)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrand', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimBrewer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimBrewer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimBrewer 
;

/* Create table dbo.DimBrewer */
CREATE TABLE dbo.DimBrewer (
   [BrewerKey]  smallint IDENTITY  NOT NULL
,  [BrewerID]  char(2)  DEFAULT '00' NOT NULL
,  [Brewer]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimBrewer] PRIMARY KEY CLUSTERED 
( [BrewerKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrewer
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BREWER', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrewer
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Beer Brewer Supplier', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrewer
;

SET IDENTITY_INSERT dbo.DimBrewer ON
;
INSERT INTO dbo.DimBrewer (BrewerKey, BrewerID, Brewer, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, 'UK', 'MISSING', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimBrewer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[BREWER]'))
DROP VIEW [Cube].[BREWER]
GO
CREATE VIEW [Cube].[BREWER] AS 
SELECT [BrewerKey] AS [Brewer Key]
, [BrewerID] AS [Brewer ID]
, [Brewer] AS [Brewer]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimBrewer
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brewer Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brewer ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'BrewerID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Beer Brewer Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, DQ, MB, C2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'MILLERCOORS, BOULDER BEER', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'UK', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'BrewerID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrewer', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimBrandSub */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimBrandSub') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimBrandSub 
;

/* Create table dbo.DimBrandSub */
CREATE TABLE dbo.DimBrandSub (
   [BrandSubKey]  smallint IDENTITY  NOT NULL
,  [BrandSubID]  char(3)  DEFAULT '000' NOT NULL
,  [BrandSub]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Brand]  varchar(30)  DEFAULT 'UNKNOWN' NULL
,  [Brewer]  varchar(30)  DEFAULT 'UNKNOWN' NULL
,  [Type]  varchar(30)  DEFAULT 'UNKNOWN' NULL
,  [Class]  varchar(30)  DEFAULT 'UNKNOWN' NULL
,  [ABV]  numeric(3,1)  DEFAULT 0 NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimBrandSub] PRIMARY KEY CLUSTERED 
( [BrandSubKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrandSub
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BRANDSUB', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrandSub
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Beer Brand Sub', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimBrandSub
;

SET IDENTITY_INSERT dbo.DimBrandSub ON
;
INSERT INTO dbo.DimBrandSub (BrandSubKey, BrandSubID, BrandSub, Brand, Brewer, Type, Class, ABV, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '000', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 0, 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, '998', 'MESSAGE', 'MESSAGE', 'MESSAGE', 'MESSAGE', 'MESSAGE', 0, 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-3, 'UNK', 'MESSAGE', 'MESSAGE', 'MESSAGE', 'MESSAGE', 'MESSAGE', 0, 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimBrandSub OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[BRANDSUB]'))
DROP VIEW [Cube].[BRANDSUB]
GO
CREATE VIEW [Cube].[BRANDSUB] AS 
SELECT [BrandSubKey] AS [Brand Sub Key]
, [BrandSubID] AS [Brand Sub ID]
, [BrandSub] AS [Brand Sub]
, [Brand] AS [Brand]
, [Brewer] AS [Brewer]
, [Type] AS [Type ID]
, [Class] AS [Class ID]
, [ABV] AS [Alcohol Percent]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimBrandSub
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand Sub Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand Sub ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand Sub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Type ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Class ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Alcohol Percent', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business Key from BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Beer Sub Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Beer Brand Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Beer Brewer Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Type ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Class ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Alcohol by Volume', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'001, 975, JA1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'COORS XGLD, RED STRIPE', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, DQ, MB, C2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'MILLERCOORS, BOULDER BEER', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'11, 35, 54', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'3.2, 4.0', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'AlcoholPercent from BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandFamilyBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'SupplierBrewerBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Product_ClassMappingNeeded', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'AlcoholPercent', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(3)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSubID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(20)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nchar(10)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimBrandSub', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimClass */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimClass') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimClass 
;

/* Create table dbo.DimClass */
CREATE TABLE dbo.DimClass (
   [ClassKey]  smallint IDENTITY  NOT NULL
,  [ClassID]  char(2)  DEFAULT '00' NOT NULL
,  [Class]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimClass] PRIMARY KEY CLUSTERED 
( [ClassKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimClass
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CLASS', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimClass
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Class', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimClass
;

SET IDENTITY_INSERT dbo.DimClass ON
;
INSERT INTO dbo.DimClass (ClassKey, ClassID, Class, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, 'UK', 'MISSING', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimClass OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[CLASS]'))
DROP VIEW [Cube].[CLASS]
GO
CREATE VIEW [Cube].[CLASS] AS 
SELECT [ClassKey] AS [Class Key]
, [ClassID] AS [Class ID]
, [Class] AS [Class]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimClass
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Class Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Class ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Class', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Class ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Class Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, 27, 45', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'ARP, STAPLETON', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR31_ProductClasses', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ClassID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimClass', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimProduct 
;

/* Create table dbo.DimProduct */
CREATE TABLE dbo.DimProduct (
   [ProductKey]  smallint IDENTITY  NOT NULL
,  [ProductID]  char(5)  DEFAULT '00000' NOT NULL
,  [Brand]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [BrandSub]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Brewer]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Product]  varchar(14)  DEFAULT 'UNKNOWN' NOT NULL
,  [Container]  char(2)  DEFAULT 'UK' NOT NULL
,  [OzPerCase]  numeric(5,1)  DEFAULT 0 NOT NULL
,  [UM]  char(2)  DEFAULT 'UK' NOT NULL
,  [Territory]  tinyint  DEFAULT 0 NOT NULL
,  [Type]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Class]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [ABV]  numeric(3,1)  DEFAULT 0 NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [Discontinued]  bit  DEFAULT 1 NOT NULL
,  [DeleteCode]  bit  DEFAULT 0 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimProduct
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Product', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimProduct
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Product Description File', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimProduct
;

SET IDENTITY_INSERT dbo.DimProduct ON
;
INSERT INTO dbo.DimProduct (ProductKey, ProductID, Brand, BrandSub, Brewer, Product, Container, UM, Territory, Type, Class, ABV, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00000', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', '00', 'UK', 00, 'UK', '00', 0, 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, '00998', 'MISSING', 'MISSING', 'MISSING', 'MISSING', '00', 'UK', 00, 'UK', '00', 0, 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[Product]'))
DROP VIEW [Cube].[Product]
GO
CREATE VIEW [Cube].[Product] AS 
SELECT [ProductKey] AS [Product Key]
, [ProductID] AS [ProductID]
, [Brand] AS [Brand]
, [BrandSub] AS [Brand Sub]
, [Brewer] AS [Brewer]
, [Product] AS [Product]
, [Container] AS [Container]
, [OzPerCase] AS [Oz/Case]
, [UM] AS [UM]
, [Territory] AS [Territory]
, [Type] AS [Type]
, [Class] AS [Class]
, [ABV] AS [Alcohol By Volume]
, [Active] AS [Active]
, [Discontinued] AS [Discontinued]
, [DeleteCode] AS [Delete Code]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimProduct
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Product Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brand Sub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Brewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Product', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Container', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Oz/Case', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Territory', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Type', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Class', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Alcohol By Volume', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Discontinued', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Delete Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Product ID Business Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Brand Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Brand Sub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Brewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Product Description', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Container Type Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Ounces Per Case', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Unit of Measure Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Territory Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Product Type Pointer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Product Class Code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Alcohol % by Volume', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Discontinued Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Delete code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'89321', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'66, 95', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'045, 237', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, 15, 96', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'24/16 PLST BTL', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 4', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'288.0, 384.0, 480.0', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'CB, HK', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 4, 8', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, NB, F3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'51, 15, 20', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'3.2, 5.6', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'padded with 0s', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'BrandSubSKUBase', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'BeerPackagingCode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Brand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Sub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Supplier', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'BeerProductDescription', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ContainerType', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Oz_Case', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'UM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Territory', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ProductTypePointer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ProductClass', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Discontinued', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'DeleteCode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'numeric(5,0)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(2)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brand'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(3)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'BrandSub'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(2)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Brewer'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(14)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Product'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(3)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Container'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'numeric(5,1)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'OzPerCase'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(2)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'numeric(3,0)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Territory'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'numeric(2,0)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(2)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Class'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'numeric(3,1)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ABV'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(1)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(1)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'DeleteCode'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimSupervisor */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimSupervisor') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimSupervisor 
;

/* Create table dbo.DimSupervisor */
CREATE TABLE dbo.DimSupervisor (
   [SupervisorKey]  smallint IDENTITY  NOT NULL
,  [SupervisorID]  char(2)  DEFAULT '00' NOT NULL
,  [Supervisor]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimSupervisor] PRIMARY KEY CLUSTERED 
( [SupervisorKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimSupervisor
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SUPERVISOR', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimSupervisor
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Supervisor', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimSupervisor
;

SET IDENTITY_INSERT dbo.DimSupervisor ON
;
INSERT INTO dbo.DimSupervisor (SupervisorKey, SupervisorID, Supervisor, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES (-1, '', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimSupervisor OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[SUPERVISOR]'))
DROP VIEW [Cube].[SUPERVISOR]
GO
CREATE VIEW [Cube].[SUPERVISOR] AS 
SELECT [SupervisorKey] AS [Supervisor Key]
, [SupervisorID] AS [Supervisor ID]
, [Supervisor] AS [Supervisor]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimSupervisor
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Supervisor Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Supervisor ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Supervisor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Supervisor ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Supervisor Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, 27, 45', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'SMITH, MEDINA', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From HR57_Supervisors', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From HR57_Supervisors', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From HR57_Supervisors', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From HR57_Supervisors', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From HR57_Supervisors', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR57_Suppliers', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR57_Suppliers', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR57_Suppliers', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'SupervisorID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Supervisor'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSupervisor', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimType */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimType') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimType 
;

/* Create table dbo.DimType */
CREATE TABLE dbo.DimType (
   [TypeKey]  smallint IDENTITY  NOT NULL
,  [TypeID]  char(2)  DEFAULT '00' NOT NULL
,  [Type]  varchar(30)  DEFAULT 'Unknown' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimType] PRIMARY KEY CLUSTERED 
( [TypeKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimType
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TYPE', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimType
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Type', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimType
;

SET IDENTITY_INSERT dbo.DimType ON
;
INSERT INTO dbo.DimType (TypeKey, TypeID, Type, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, 'UK', 'MISSING', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimType OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[TYPE]'))
DROP VIEW [Cube].[TYPE]
GO
CREATE VIEW [Cube].[TYPE] AS 
SELECT [TypeKey] AS [Type Key]
, [TypeID] AS [Class ID]
, [Type] AS [Type]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimType
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Type Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Class ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Type', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Class ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Product Type', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'01, 27, 45', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'CASE, KEG', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From  HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From  HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'TypeID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimType', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimMode */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimMode') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimMode 
;

/* Create table dbo.DimMode */
CREATE TABLE dbo.DimMode (
   [ModeKey]  smallint IDENTITY  NOT NULL
,  [ModeID]  char(1)   NOT NULL
,  [Mode]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimMode] PRIMARY KEY CLUSTERED 
( [ModeKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimMode
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'MODE', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimMode
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Type', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimMode
;

SET IDENTITY_INSERT dbo.DimMode ON
;
INSERT INTO dbo.DimMode (ModeKey, ModeID, Mode, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES (-1, '', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimMode OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[MODE]'))
DROP VIEW [Cube].[MODE]
GO
CREATE VIEW [Cube].[MODE] AS 
SELECT [ModeKey] AS [ModeKey]
, [ModeID] AS [ModeID]
, [Mode] AS [Mode]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimMode
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ModeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ModeID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Mode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'ModeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'ModeID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Mode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, ', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'CASE, KEG', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModeID From Mode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From  HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From  HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From HR11_MarketTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModeID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Mode'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimMode', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;





/* Drop table dbo.DimReason */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimReason') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimReason 
;

/* Create table dbo.DimReason */
CREATE TABLE dbo.DimReason (
   [ReasonKey]  smallint IDENTITY  NOT NULL
,  [ReasonID]  char(2)  DEFAULT '00' NOT NULL
,  [Reason]  varchar(30)  DEFAULT 'UNKNOWN' NOT NULL
,  [Active]  bit  DEFAULT 1 NOT NULL
,  [CreatedOn]  datetime   NOT NULL
,  [ModifiedOn]  datetime   NULL
,  [RowIsCurrent]  char(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  varchar(200)   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
, CONSTRAINT [PK_dbo.DimReason] PRIMARY KEY CLUSTERED 
( [ReasonKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimReason
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'REASON', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimReason
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Type', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimReason
;

SET IDENTITY_INSERT dbo.DimReason ON
;
INSERT INTO dbo.DimReason (ReasonKey, ReasonID, Reason, Active, CreatedOn, ModifiedOn, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason, InsertAuditKey, UpdateAuditKey)
VALUES
	(-1, '00', 'UNKNOWN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-2, '18', 'REASON18', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-3, 'BE', 'REASONBE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-4, '0-' , 'REASON0-', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-5, '0=' , 'REASON0=', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-6, '0@' , 'REASON0@', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-7, '0B' , 'REASON0B', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-8, '0E' , 'REASON0E', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-9, '0J' , 'REASON0J', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-10, '0N' , 'REASON0N', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-11, '0Q' , 'REASON0Q', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-12, '0R' , 'REASON0R', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-13, '0S' , 'REASON0S', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-14, '0Y' , 'REASON0Y', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-15, '15' , 'REASON15', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-16, '17' , 'REASON17', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-17, '3-' , 'REASON3-', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-18, '49' , 'REASON49', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-19, '50' , 'REASON50', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-20, '6-' , 'REASON6-', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-21, '64' , 'REASON64', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-22, '77' , 'REASON77', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-23, '79' , 'REASON79', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-24, '80' , 'REASON80', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-25, '83' , 'REASON83', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-26, '91' , 'REASON91', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-27, 'AD' , 'REASONAD', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-28, 'AL' , 'REASONAL', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-29, 'AS' , 'REASONAS', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-30, 'BI' , 'REASONBI', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-31, 'BR' , 'REASONBR', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-32, 'CD' , 'REASONCD', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-33, 'CH' , 'REASONCH', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-34, 'CO' , 'REASONCO', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-35, 'CR' , 'REASONCR', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-36, 'CU' , 'REASONCU', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-37, 'DA' , 'REASONDA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-38, 'DT' , 'REASONDT', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-39, 'FA' , 'REASONFA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-40, 'FD' , 'REASONFD', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-41, 'FI' , 'REASONFI', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-42, 'FO' , 'REASONFO', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-43, 'GE' , 'REASONGE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-44, 'GO' , 'REASONGO', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-45, 'HE' , 'REASONHE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-46, 'HL' , 'REASONHL', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-47, 'IN' , 'REASONIN', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-48, 'JA' , 'REASONJA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-49, 'JE' , 'REASONJE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-50, 'JI' , 'REASONJI', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-51, 'JO' , 'REASONJO', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-52, 'JP' , 'REASONJP', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-53, 'JS' , 'REASONJS', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-54, 'KE' , 'REASONKE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-55, 'LE' , 'REASONLE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-56, 'MA' , 'REASONMA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-57, 'ME' , 'REASONME', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-58, 'MI' , 'REASONMI', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-59, 'NE' , 'REASONNE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-60, 'NG' , 'REASONNG', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-61, 'OE' , 'REASONOE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-62, 'RO' , 'REASONRO', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-63, 'RU' , 'REASONRU', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-64, 'RY' , 'REASONRY', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-65, 'SA' , 'REASONSA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-66, 'SU' , 'REASONSU', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-67, 'TA' , 'REASONTA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-68, 'TE' , 'REASONTE', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-69, 'TO' , 'REASONTO', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-70, 'TR' , 'REASONTR', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-71, 'TY' , 'REASONTY', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-72, 'VA' , 'REASONVA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-73, 'WA' , 'REASONWA', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1),
	(-74, 'WI' , 'REASONWI', 1, '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A', -1, -1)
;
SET IDENTITY_INSERT dbo.DimReason OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[REASON]'))
DROP VIEW [Cube].[REASON]
GO
CREATE VIEW [Cube].[REASON] AS 
SELECT [ReasonKey] AS [ReasonKey]
, [ReasonID] AS [ReasonID]
, [Reason] AS [Reason]
, [Active] AS [Active]
, [CreatedOn] AS [Created On]
, [ModifiedOn] AS [Modified On]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
, [InsertAuditKey] AS [InsertAuditKey]
, [UpdateAuditKey] AS [UpdateAuditKey]
FROM dbo.DimReason
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ReasonKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ReasonID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'InsertAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UpdateAuditKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'ReasonKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'ReasonID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Active Flag', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Created On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Modified On', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process loaded this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'What process most recently updated this row?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, ', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'FULL-BREAKAGE                 ', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0, 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'8/23/2012 8:22:22 AM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ID From HR03_ReconAdjustmentReasons', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Name From HR03_ReconAdjustmentReasons', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Active From HR03_ReconAdjustmentReasons', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'CreatedOn From HR03_ReconAdjustmentReasons', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'ModifiedOn From HR03_ReconAdjustmentReasons', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard Audit dim', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'CDCMART', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR20_ProductTypes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'HR01_Routes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Active', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ModifiedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(5)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ReasonID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar(30)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Reason'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'Active'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'datetime', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimReason', @level2type=N'COLUMN', @level2name=N'ModifiedOn'; 
;




/* Drop table dbo.FactDailyT */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactDailyT') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactDailyT 
;

/* Create table dbo.FactDailyT */
CREATE TABLE dbo.FactDailyT (
   [AccountKey]  smallint   NOT NULL
,  [ProductKey]  smallint   NOT NULL
,  [BrandKey]  smallint   NOT NULL
,  [BrandSubKey]  smallint   NOT NULL
,  [BrewerKey]  smallint   NOT NULL
,  [AreaKey]  smallint   NOT NULL
,  [SupervisorKey]  smallint   NOT NULL
,  [ClassKey]  smallint   NOT NULL
,  [TypeKey]  smallint   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ModeKey]  smallint   NOT NULL
,  [ReasonKey]  smallint   NOT NULL
,  [OrderNum]  varchar(9)   NULL
,  [OrderLine]  smallint   NULL
,  [UM]  char(2)   NULL
,  [Qty]  smallint   NULL
,  [Oz]  numeric(11,1)   NULL
,  [Cost]  money   NULL
,  [AveCost]  money   NULL
,  [Price]  money   NULL
,  [ExtPrice]  money   NULL
,  [FrontLinePrice]  money   NULL
,  [Discount]  money   NULL
,  [ExtAmt]  money   NULL
,  [ExtDisc]  money   NULL
,  [SalesAmt]  money   NULL
,  [CreatedOn]  datetime   NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Fact', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactDailyT
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DAILYT', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactDailyT
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Daily Transactions', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactDailyT
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[DAILYT]'))
DROP VIEW [Cube].[DAILYT]
GO
CREATE VIEW [Cube].[DAILYT] AS 
SELECT [AccountKey] AS [AccountKey]
, [ProductKey] AS [ProductKey]
, [BrandKey] AS [BrandKey]
, [BrandSubKey] AS [BrandSubKey]
, [BrewerKey] AS [BrewerKey]
, [AreaKey] AS [AreaKey]
, [SupervisorKey] AS [SupervisorKey]
, [ClassKey] AS [ClassKey]
, [TypeKey] AS [TypeKey]
, [OrderDateKey] AS [OrderDateKey]
, [ModeKey] AS [ModeKey]
, [ReasonKey] AS [ReasonKey]
, [OrderNum] AS [Order Number]
, [OrderLine] AS [Order Line Number]
, [UM] AS [UM]
, [Qty] AS [Order Qty]
, [Oz] AS [Order Oz]
, [Cost] AS [Cost]
, [AveCost] AS [Average Cost]
, [Price] AS [Price]
, [ExtPrice] AS [Extended Price]
, [FrontLinePrice] AS [Front Line Price]
, [Discount] AS [Discount Amount]
, [ExtAmt] AS [Extended Amount]
, [ExtDisc] AS [Extended Discount]
, [SalesAmt] AS [Sales Amount]
, [CreatedOn] AS [CreatedOn]
, [InsertAuditKey] AS [Insert Audit Key]
, [UpdateAuditKey] AS [Update Audit Key]
FROM dbo.FactDailyT
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'AccountKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BrandKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BrandSubKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BrewerKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'AreaKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SupervisorKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ClassKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TypeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'OrderDateKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ModeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ReasonKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderNum'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Line Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderLine'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Qty', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Qty'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Oz', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Oz'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Cost', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Cost'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Average Cost', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AveCost'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Extended Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtPrice'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Front Line Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'FrontLinePrice'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Discount Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Discount'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Extended Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Extended Discount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtDisc'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Sales Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SalesAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Insert Audit Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Update Audit Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimAccount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimProduct', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimBrand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimBrandSub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimBrewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimArea', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimSupervisor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimClass', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimType', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimDate', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimMode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimReason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderNum'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Line Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderLine'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Unit of Measure', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Quantity', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Qty'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Ounces', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Oz'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Cost of Sales', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Cost'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Average Cost', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AveCost'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtPrice'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Front Line Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'FrontLinePrice'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Discount Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Discount'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtAmt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended Discount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtDisc'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Sales Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SalesAmt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Audit dimension for row insertion', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Audit dimension for row update', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderNum'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderLine'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Qty'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Oz'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Cost'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AveCost'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtPrice'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'FrontLinePrice'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'Discount'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Totals', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Totals', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ExtDisc'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Totals', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SalesAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimAccount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimProduct', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimBrand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimBrandSub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimBrewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimManager', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimSupervisor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimClass', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimType', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimDate', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimMode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimReason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard auditing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard auditing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard auditing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyT', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
;





/* Drop table dbo.FactDailyTErr */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactDailyTErr') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactDailyTErr 
;

/* Create table dbo.FactDailyTErr */
CREATE TABLE dbo.FactDailyTErr (
   [AccountKey]  smallint   NULL
,  [ProductKey]  smallint   NULL
,  [BrandKey]  smallint   NULL
,  [BrandSubKey]  smallint   NULL
,  [BrewerKey]  smallint   NULL
,  [AreaKey]  smallint   NULL
,  [SupervisorKey]  smallint   NULL
,  [ClassKey]  smallint   NULL
,  [TypeKey]  smallint   NULL
,  [OrderDateKey]  int   NULL
,  [ModeKey]  smallint   NULL
,  [ReasonKey]  smallint   NULL
,  [OrderNum]  varchar(9)   NULL
,  [OrderLine]  smallint   NULL
,  [UM]  char(2)   NULL
,  [Qty]  smallint   NULL
,  [Oz]  numeric(11,1)   NULL
,  [Cost]  money   NULL
,  [AveCost]  money   NULL
,  [Price]  money   NULL
,  [ExtPrice]  money   NULL
,  [FrontLinePrice]  money   NULL
,  [Discount]  money   NULL
,  [ExtAmt]  money   NULL
,  [ExtDisc]  money   NULL
,  [SalesAmt]  money   NULL
,  [CreatedOn]  datetime   NOT NULL
,  [InsertAuditKey]  int   NOT NULL
,  [UpdateAuditKey]  int   NOT NULL
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Fact', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactDailyTErr
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DAILYTErr', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactDailyTErr
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Daily Transactions', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactDailyTErr
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Cube].[DAILYTErr]'))
DROP VIEW [Cube].[DAILYTErr]
GO
CREATE VIEW [Cube].[DAILYTErr] AS 
SELECT [AccountKey] AS [AccountKey]
, [ProductKey] AS [ProductKey]
, [BrandKey] AS [BrandKey]
, [BrandSubKey] AS [BrandSubKey]
, [BrewerKey] AS [BrewerKey]
, [AreaKey] AS [AreaKey]
, [SupervisorKey] AS [SupervisorKey]
, [ClassKey] AS [ClassKey]
, [TypeKey] AS [TypeKey]
, [OrderDateKey] AS [OrderDateKey]
, [ModeKey] AS [ModeKey]
, [ReasonKey] AS [ReasonKey]
, [OrderNum] AS [Order Number]
, [OrderLine] AS [Order Line Number]
, [UM] AS [UM]
, [Qty] AS [Order Qty]
, [Oz] AS [Order Oz]
, [Cost] AS [Cost]
, [AveCost] AS [Average Cost]
, [Price] AS [Price]
, [ExtPrice] AS [Extended Price]
, [FrontLinePrice] AS [Front Line Price]
, [Discount] AS [Discount Amount]
, [ExtAmt] AS [Extended Amount]
, [ExtDisc] AS [Extended Discount]
, [SalesAmt] AS [Sales Amount]
, [CreatedOn] AS [CreatedOn]
, [InsertAuditKey] AS [Insert Audit Key]
, [UpdateAuditKey] AS [Update Audit Key]
FROM dbo.FactDailyTErr
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'AccountKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BrandKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BrandSubKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'BrewerKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'AreaKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SupervisorKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ClassKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'TypeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'OrderDateKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ModeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ReasonKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderNum'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Line Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderLine'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'UM', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Qty', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Qty'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Order Oz', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Oz'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Cost', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Cost'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Average Cost', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AveCost'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Extended Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtPrice'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Front Line Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'FrontLinePrice'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Discount Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Discount'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Extended Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Extended Discount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtDisc'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Sales Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SalesAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Insert Audit Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Update Audit Key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimAccount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimProduct', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimBrand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimBrandSub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimBrewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimArea', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimSupervisor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimClass', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimType', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimDate', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimMode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to DimReason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderNum'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Line Number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderLine'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Unit of Measure', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Quantity', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Qty'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Order Ounces', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Oz'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Cost of Sales', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Cost'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Average Cost', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AveCost'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtPrice'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Front Line Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'FrontLinePrice'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Discount Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Discount'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtAmt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended Discount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtDisc'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Sales Amount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SalesAmt'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'CreatedOn', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Audit dimension for row insertion', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Audit dimension for row update', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Dims', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderNum'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderLine'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UM'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Qty'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Oz'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Cost'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AveCost'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtPrice'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'FrontLinePrice'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Orders', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'Discount'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Totals', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Totals', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ExtDisc'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Totals', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SalesAmt'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimAccount', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AccountKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimProduct', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimBrand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimBrandSub', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrandSubKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimBrewer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'BrewerKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimManager', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'AreaKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimSupervisor', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'SupervisorKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimClass', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ClassKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimType', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'TypeKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimDate', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimMode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ModeKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from dbo.DimReason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'ReasonKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard auditing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'CreatedOn'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard auditing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'InsertAuditKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard auditing', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactDailyTErr', @level2type=N'COLUMN', @level2name=N'UpdateAuditKey'; 
;
ALTER TABLE dbo.DimAccount ADD CONSTRAINT
   FK_dbo_DimAccount_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimAccount ADD CONSTRAINT
   FK_dbo_DimAccount_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimArea ADD CONSTRAINT
   FK_dbo_DimArea_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimArea ADD CONSTRAINT
   FK_dbo_DimArea_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimBrand ADD CONSTRAINT
   FK_dbo_DimBrand_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimBrand ADD CONSTRAINT
   FK_dbo_DimBrand_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimBrewer ADD CONSTRAINT
   FK_dbo_DimBrewer_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimBrewer ADD CONSTRAINT
   FK_dbo_DimBrewer_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimBrandSub ADD CONSTRAINT
   FK_dbo_DimBrandSub_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimBrandSub ADD CONSTRAINT
   FK_dbo_DimBrandSub_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimClass ADD CONSTRAINT
   FK_dbo_DimClass_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimClass ADD CONSTRAINT
   FK_dbo_DimClass_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimProduct ADD CONSTRAINT
   FK_dbo_DimProduct_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimProduct ADD CONSTRAINT
   FK_dbo_DimProduct_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimSupervisor ADD CONSTRAINT
   FK_dbo_DimSupervisor_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimSupervisor ADD CONSTRAINT
   FK_dbo_DimSupervisor_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimType ADD CONSTRAINT
   FK_dbo_DimType_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimType ADD CONSTRAINT
   FK_dbo_DimType_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimMode ADD CONSTRAINT
   FK_dbo_DimMode_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimMode ADD CONSTRAINT
   FK_dbo_DimMode_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimReason ADD CONSTRAINT
   FK_dbo_DimReason_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.DimReason ADD CONSTRAINT
   FK_dbo_DimReason_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_AccountKey FOREIGN KEY
   (
   AccountKey
   ) REFERENCES DimAccount
   ( AccountKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_BrandKey FOREIGN KEY
   (
   BrandKey
   ) REFERENCES DimBrand
   ( BrandKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_BrandSubKey FOREIGN KEY
   (
   BrandSubKey
   ) REFERENCES DimBrandSub
   ( BrandSubKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_BrewerKey FOREIGN KEY
   (
   BrewerKey
   ) REFERENCES DimBrewer
   ( BrewerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_AreaKey FOREIGN KEY
   (
   AreaKey
   ) REFERENCES DimArea
   ( AreaKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_SupervisorKey FOREIGN KEY
   (
   SupervisorKey
   ) REFERENCES DimSupervisor
   ( SupervisorKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_ClassKey FOREIGN KEY
   (
   ClassKey
   ) REFERENCES DimClass
   ( ClassKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_TypeKey FOREIGN KEY
   (
   TypeKey
   ) REFERENCES DimType
   ( TypeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_ModeKey FOREIGN KEY
   (
   ModeKey
   ) REFERENCES DimMode
   ( ModeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_ReasonKey FOREIGN KEY
   (
   ReasonKey
   ) REFERENCES DimReason
   ( ReasonKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyT ADD CONSTRAINT
   FK_dbo_FactDailyT_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_AccountKey FOREIGN KEY
   (
   AccountKey
   ) REFERENCES DimAccount
   ( AccountKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_BrandKey FOREIGN KEY
   (
   BrandKey
   ) REFERENCES DimBrand
   ( BrandKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_BrandSubKey FOREIGN KEY
   (
   BrandSubKey
   ) REFERENCES DimBrandSub
   ( BrandSubKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_BrewerKey FOREIGN KEY
   (
   BrewerKey
   ) REFERENCES DimBrewer
   ( BrewerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_AreaKey FOREIGN KEY
   (
   AreaKey
   ) REFERENCES DimArea
   ( AreaKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_SupervisorKey FOREIGN KEY
   (
   SupervisorKey
   ) REFERENCES DimSupervisor
   ( SupervisorKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_ClassKey FOREIGN KEY
   (
   ClassKey
   ) REFERENCES DimClass
   ( ClassKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_TypeKey FOREIGN KEY
   (
   TypeKey
   ) REFERENCES DimType
   ( TypeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_ModeKey FOREIGN KEY
   (
   ModeKey
   ) REFERENCES DimMode
   ( ModeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactDailyTErr ADD CONSTRAINT
   FK_dbo_FactDailyTErr_ReasonKey FOREIGN KEY
   (
   ReasonKey
   ) REFERENCES DimReason
   ( ReasonKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
