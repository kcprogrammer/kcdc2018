use AdventureWorks2016
GO
/*
ALTER DATABASE [AdventureWorks2016] SET PARAMETERIZATION SIMPLE 
GO
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLineTotal]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetLineTotal]
GO
CREATE PROCEDURE [dbo].[GetLineTotal](@SalesOrderID INT)
AS
SELECT  SUM(LineTotal) AS LineTotal
FROM	Sales.SalesOrderHeader H
JOIN	Sales.SalesOrderDetail D ON D.SalesOrderID = H.SalesOrderID
WHERE	H.SalesOrderID = @SalesOrderID
-- AND		H.TerritoryID = 11
GO

DBCC FREEPROCCACHE
GO

EXEC [dbo].[GetLineTotal] 44347
GO
EXEC [dbo].[GetLineTotal]      44347
GO
EXEC GETLINETOTAL 44347
GO
EXEC [dbo].[GetLineTotal] @SalesOrderID = 44348
GO



select  [sql].[text], stats.execution_count, p.size_in_bytes
from sys.dm_exec_cached_plans p
outer apply sys.dm_exec_sql_text (p.plan_handle) sql
join sys.dm_exec_query_stats stats ON stats.plan_handle = p.plan_handle
GO

------------------------------------------------------------------------------------------------------
-- Dynamic SQL
------------------------------------------------------------------------------------------------------


use AdventureWorks2016
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLineTotalDynamic]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetLineTotalDynamic]
GO

CREATE PROC [dbo].[GetLineTotalDynamic](@SalesOrderID INT)
AS

DECLARE @SQL NVARCHAR(4000)
SELECT @SQL = '
SELECT  SUM(LineTotal) AS LineTotal
FROM	Sales.SalesOrderHeader H
JOIN	Sales.SalesOrderDetail D ON D.SalesOrderID = H.SalesOrderID
WHERE	H.SalesOrderID = ' + CAST(@SalesOrderID AS NVARCHAR) + '
AND		H.TerritoryID = 10'
EXEC (@SQL)

SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID
GO

DBCC FREEPROCCACHE
GO

set dateformat MDY
-- set dateformat YMD

EXEC [dbo].[GetLineTotalDynamic] 43935
GO
EXEC [dbo].[GetLineTotalDynamic]      43941
GO
EXEC [GetLineTotalDynamic] 43955
GO
EXEC [dbo].[GetLineTotalDynamic] @SalesOrderID = 44063
GO


select  [sql].[text], stats.execution_count, p.size_in_bytes
from sys.dm_exec_cached_plans p
outer apply sys.dm_exec_sql_text (p.plan_handle) sql
join sys.dm_exec_query_stats stats ON stats.plan_handle = p.plan_handle
GO



/*
ALTER DATABASE [AdventureWorks2016] SET PARAMETERIZATION FORCED 
GO
ALTER DATABASE [AdventureWorks2016] SET PARAMETERIZATION SIMPLE 
GO
*/

ALTER DATABASE [AdventureWorks2016] SET PARAMETERIZATION SIMPLE 
GO