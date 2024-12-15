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


SET IDENTITY_INSERT dbo.DimAudit ON
;
INSERT INTO dbo.DimAudit (AuditKey, ParentAuditKey, TableName, PkgName, PkgGUID, PkgVersionGUID, PkgVersionMajor, PkgVersionMinor, ExecStartDT, ExecStopDT, ExecutionInstanceGUID, ExtractRowCnt, InsertRowCnt, UpdateRowCnt, ErrorRowCnt, TableInitialRowCnt, TableFinalRowCnt, TableMaxSurrogateKey, SuccessfulProcessingInd)
VALUES (-1, -1, 'Audit', 'None: Dummy row', NULL, NULL, NULL, NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y')
;
SET IDENTITY_INSERT dbo.DimAudit OFF
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
 
