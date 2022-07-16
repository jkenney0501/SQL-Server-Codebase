/* 

Data - Microsoft Adventureworks 2019
Date - 7/14/2022

Windows Functions
   - What they are and what they do

Exploring the OVER( ) clause
Example: SUM(SALESYTD) OVER()

The above query sums the sales YTD and applies the sum function OVER the entre set becaseu no arguments are passed to OVER(). 

*/

-- Window Funcs work where traditional aggregate functions will not (DUE TO COLLLAPSE OF ROWS). Example, using the OVER() clause, we can compare each row of sales to the overall sum of all sales.
-- Window functions allow you retain the row level while showing the same calcs a traditional function uses.
SELECT
[BusinessEntityID],
[TerritoryID],
[SalesQuota],
[Bonus],
[CommissionPct],
[SalesYTD],
SUM(salesYTD) OVER() AS Total_YTD_Sales, -- this provides the sum of all sales in the data set
MAX(salesYTD) OVER() AS Max_YTD_Sales, -- the max value of YTD sales which can be used to compare to each row
salesYTD/SUM(salesYTD) OVER() AS Percent_of_Total_YTD_Sales -- this uses the row level sales and the total sales for a percent of all sales.
FROM [Sales].[SalesPerson]





/*****************************PARTITION BY****************************************/

-- To add rows into GROUPS, we use PARTITION 
-- PARTITION allows us to group like rows (think state, sales person or any row that can have more than one result per attribute similar to a salesperson having > 1 sale).
-- We can use OVER and roll the totals into groups
-- We have to specify the columns to be grouped

--*******************************************************************************/
SELECT
[ProductID],
[SalesOrderID],
[SalesOrderDetailID],
[OrderQty],
[UnitPrice],
[UnitPriceDiscount],
[LineTotal],
SUM(LineTotal) OVER(PARTITION BY ProductID, [OrderQty]) AS ProductIDLineTotal
FROM [Sales].[SalesOrderDetail]
ORDER BY ProductID, OrderQty





/*****************************ROW_NUMBER()****************************************/

-- ROW NUMBER allows us to rank records(rows) within groups (or windows) in conjunction with PARTITION BY
-- Order by must be included in your OVER() statment becaseu you are essentially ranking.

-- look at rows 9/10, 12/13, they are the same for line total but are ranked differently.Rnak.DENSE_RANK will deal with this issue.
--*******************************************************************************/
SELECT
[SalesOrderID],
[SalesOrderDetailID],
[LineTotal],
SUM(LineTotal) OVER(PARTITION BY [SalesOrderID]) AS ProductIDLineTotal,
ROW_NUMBER() OVER(PARTITION BY [SalesOrderID] ORDER BY linetotal) AS Ranking, -- Ranking the line total so descending order is needed with the largest value being #1, highest within the group
ROW_NUMBER() OVER(ORDER BY linetotal desc) AS TotalRanking -- highest over all ranking of the set
FROM [Sales].[SalesOrderDetail]
ORDER BY TotalRanking






/*****************************RANK()/DENSE_RANK()****************************************/
-- provides a unique rank when values are the same: breaks ties!
-- ROWS 4-7 show that RANK will recognize a tie and RANK as such.
-- DENSE_RANK however will handle ties differently, it stays with the sequence where RANK will skip.
-- In other words, as below, rows 3-5 are all values of 3 with RANK and the next value change would be 6 due to 3 values of 3 consecutively but 
-- DENSE_RANK would not skip sequence, the next value would be a 4.

-- WHICH ONE TO USE? Its depends. ROW_NUMBER is the most common and typicaly provides what you need.
-- If you need a specialized way of identifying rows that have the same values, then rank of dense rank would be best.
--***************************************************************************************/
SELECT
[SalesOrderID],
[SalesOrderDetailID],
[LineTotal],
SUM(LineTotal) OVER(PARTITION BY [SalesOrderID]) AS ProductIDLineTotal,
ROW_NUMBER() OVER(PARTITION BY [SalesOrderID] ORDER BY linetotal desc) AS Ranking_with_ROW, -- Orders as highest value within the group
RANK() OVER(PARTITION BY SalesOrderID ORDER BY linetotal desc) AS Ranking_with_RANK, -- skips sequence by number of ties
DENSE_RANK() OVER(PARTITION BY SalesOrderID ORDER BY linetotal desc) AS Ranking_with_DENSE_RANK -- does not skip sequence but does recognize ties
FROM [Sales].[SalesOrderDetail]
ORDER BY [SalesOrderID],[LineTotal] DESC





/*****************************LEAD & LAG()****************************************/

-- ROW NUMBER allows us to rank records(rows) within groups (or windows) in conjunction with PARTITION BY

--*******************************************************************************/