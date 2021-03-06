﻿/*
Deployment script for tpa

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "tpa"
:setvar DefaultFilePrefix "tpa"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO, OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30)) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column date on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column day on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column day_of_week on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column day_of_year on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column month on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column month_name on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column quarter on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column week on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column weekday on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column year on table [dbo].[calendar] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[calendar])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Creating [usqllogin]...';


GO
CREATE LOGIN [usqllogin]
    WITH PASSWORD = N'jIjpeatFxcmi|vsSmmbnhcwdmsFT7_&#$!~<%tf8kcGqrW|d';


GO
PRINT N'Creating [usqluser]...';


GO
CREATE USER [usqluser] FOR LOGIN [usqllogin];


GO
REVOKE CONNECT TO [usqluser];


GO
PRINT N'Creating <unnamed>...';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'usqluser';


GO
PRINT N'Creating <unnamed>...';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'usqluser';


GO
PRINT N'Altering [dbo].[calendar]...';


GO
ALTER TABLE [dbo].[calendar] ALTER COLUMN [date] DATE NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [day] INT NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [day_of_week] INT NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [day_of_year] INT NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [month] INT NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [month_name] NVARCHAR (30) NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [quarter] INT NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [week] INT NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [weekday] NVARCHAR (30) NOT NULL;

ALTER TABLE [dbo].[calendar] ALTER COLUMN [year] INT NOT NULL;


GO
PRINT N'Creating [dbo].[airport]...';


GO
CREATE TABLE [dbo].[airport] (
    [iata_code] VARCHAR (3)  NOT NULL,
    [city]      VARCHAR (64) NOT NULL,
    CONSTRAINT [PK_Airport] PRIMARY KEY CLUSTERED ([iata_code] ASC)
);


GO
PRINT N'Creating [dbo].[station_iata]...';


GO
CREATE TABLE [dbo].[station_iata] (
    [id]           VARCHAR (11) NOT NULL,
    [latitude]     FLOAT (53)   NULL,
    [longitude]    FLOAT (53)   NULL,
    [elevation]    FLOAT (53)   NULL,
    [state]        VARCHAR (2)  NULL,
    [name]         VARCHAR (30) NULL,
    [gsn_flag]     VARCHAR (3)  NULL,
    [hcn_crn_flag] VARCHAR (3)  NULL,
    [wmo_id]       VARCHAR (5)  NULL,
    [iata_code]    VARCHAR (3)  NULL,
    [iata_city]    VARCHAR (64) NULL,
    CONSTRAINT [PK_station_iata] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

begin tran;

	truncate table dbo.calendar;

	with cte ([date])
	as (
		select DATEFROMPARTS(2010,1,1)
		union all
		select dateadd(day,1,[date])
		from cte
		where [date] < DATEFROMPARTS(2018,1,1)
	)

	insert dbo.calendar (
		 [datekey]
		,[date]
		,[year]
		,[month]
		,[day]
		,[day_of_year]
		,[day_of_week]
		,[quarter]
		,[week]
		,[month_name]
		,[weekday]
	)
	select 
		 convert(int, convert(varchar(8), [date], 112)) as [datekey]
		,[date]
		,datepart(year, [date]) as [year]
		,datepart(month, [date]) as [month]
		,datepart(day, [date]) as [day]
		,dateparT(dayofyear, [date]) as [day_of_year]
		,datepart(weekday, [date]) as [day_of_week]
		,datepart(quarter, [date]) as [quarter]
		,datepart(week, [date]) as [week]
		,datename(month, [date]) as [month_name]
		,datename(weekday, [date]) as [weekday]
	from cte
	option (maxrecursion 32767)

commit tran;

begin tran;

	truncate table dbo.airport;

	insert dbo.Airport (iata_code, city) values
		('ATL','Atlanta'),
		('ORD','Chicago'),
		('LAX','Los Angeles'),
		('DFW','Dallas-Fort Worth'),
		('DEN','Denver'),
		('JFK','New York'),
		('SFO','San Francisco'),
		('CLT','Charlotte'),
		('LAS','Las Vegas'),
		('PHX','Phoenix'),
		('IAH','Houston'),
		('MIA','Miami'),
		('MCO','Orlando'),
		('EWR','Newark'),
		('SEA','Seattle'),
		('MSP','Minneapolis'),
		('DTW','Detroit'),
		('PHL','Philadelphia'),
		('BOS','Boston'),
		('LGA','New York'),
		('FLL','Fort Lauderdale'),
		('BWI','Baltimore'),
		('IAD','Washington'),
		('SLC','Salt Lake City'),
		('DCA','Washington'),
		('MDW','Chicago'),
		('HNL','Honolulu'),
		('SAN','San Diego'),
		('TPA','Tampa'),
		('CLE','Cleveland'),
		('PDX','Portland'),
		('STL','St Louis'),
		('HOU','Houston'),
		('OAK','Oakland'),
		('MCI','Kansas City'),
		('BNA','Nashville'),
		('AUS','Austin'),
		('RDU','Raleigh/Durham'),
		('SMF','Sacramento'),
		('SNA','Santa Ana');

commit tran;

begin tran;

	truncate table station_iata;

	with airport_station
	as (
		select a.iata_code
			,a.city
			,s.id
			,row_number() over (partition by iata_code order by s.name) as top_station
			,s.geo
		from dbo.airport a
		join dbo.station s on s.name like a.city + '%'
	)

	,station_iata
	AS (
		 select s.*
			,a.iata_code
			,a.city as iata_city
			,row_number() over (partition by s.id order by s.geo.STDistance(a.geo)) as nearest_iata
		from dbo.station s
		left outer join airport_station a on a.top_station = 1 and s.geo.STDistance(a.geo) < 1609 * 25
	)

	INSERT dbo.station_iata (
		id
		,latitude
		, longitude
		, elevation
		, [state]
		, name
		, gsn_flag
		, hcn_crn_flag
		, wmo_id
		, iata_code
		, iata_city
		)
	select id
		,latitude
		,longitude
		,elevation
		, [state]
		, name
		, gsn_flag
		, hcn_crn_flag
		, wmo_id
		, iata_code
		, iata_city

	from station_iata
	where nearest_iata = 1

commit tran;
GO

GO
PRINT N'Update complete.';


GO
