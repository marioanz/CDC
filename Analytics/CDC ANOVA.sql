SELECT 
TOP 25
       CONVERT(Date, CAST([OrderDateKey] AS CHAR(8)), 6) Date
      CASE
		WHEN [Brand] = 'CORONA EXTRA' THEN 'CORONA'
		ELSE [Brand]
		END AS Brand
		--,[Brand]
	  ,b.[BrandKey]
      --,[Qty]
      --,[ExtAmt]
      ,SUM([Qty] * [ExtAmt]) AS [SalesAmt]
  FROM [CDCCube].[dbo].[FactDailyT]
  JOIN dbo.DimBrand b on b.BrandKey = dbo.FactDailyT.BrandKey
  WHERE [Qty] BETWEEN -10 AND 100 
  AND [ExtAmt] BETWEEN 1 AND 500
  AND OrderDateKey BETWEEN 20130101 AND 20131231
  AND b.[BrandKey] IN (2, 90, 84, 154, 5, 23, 1, 145, 26, 13, 6, 62, 81, 
						73, 87, 61, 100, 24, 38, 184, 22, 3, 98, 107)
  GROUP BY b.[Brand], b.[BrandKey]
  ORDER BY [SalesAmt] DESC
 

