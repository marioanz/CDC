SELECT 
	   fdt.OrderNum
	  ,b.[BrandKey] AS StockCode
      ,b.[Brand] AS Brand
      ,fdt.[Qty]
      ,CONVERT(Date, CAST([OrderDateKey] AS CHAR(8)), 6) AS OrderDate
	  ,fdt.Price AS UnitPrice
	  ,fdt.AccountKey AS CustomerKey
	  ,a.AreaKey as Campaign
	  ,c.ClassKey as State
	  ,m.ModeKey as Channel
      ,fdt.[Qty] * fdt.[ExtAmt] AS 'Sales Amount'
  FROM [CDCCube].[dbo].[FactDailyT] fdt
  JOIN dbo.DimBrand b on b.BrandKey = fdt.BrandKey
  JOIN dbo.DimArea a on a.AreaKey = fdt.AreaKey
  JOIN dbo.DimClass c on c.ClassKey = fdt.ClassKey
  JOIN dbo.DimMode m on m.ModeKey = fdt.ModeKey
  WHERE [Qty] BETWEEN 10 AND 100 
	  AND [ExtAmt] BETWEEN 1 AND 500
	  AND OrderDateKey BETWEEN 2010101 AND 20141231
	  AND b.[BrandKey] IN (2, 90, 84, 154, 5, 23, 1, 145, 26, 13, 6, 62, 81, 
						73, 87, 61, 100, 24, 38, 184, 22, 3, 98, 107)
	ORDER BY [Brand] DESC

 

