/********************************************************************************************************************************************

ROLL UP

Sample database found here: https://www.sqlservertutorial.net/sql-server-sample-database/

The SQL Server ROLLUP is a subclause of the GROUP BY clause which provides a shorthand for defining multiple grouping sets. 
Unlike the CUBE subclause, ROLLUP does not create all possible grouping sets based on the dimension columns; the CUBE makes a subset of those.
When generating the grouping sets, ROLLUP assumes a hierarchy among the dimension columns and only generates grouping sets based on this hierarchy.

The ROLLUP is often used to generate subtotals and totals for reporting purposes.

SYNTAX EXAMPLE:
SELECT
    d1,
    d2,
    d3,
    aggregate_function(c4)
FROM
    table_name
GROUP BY
    ROLLUP (d1, d2, d3);

In this syntax, d1, d2, and d3 are the dimension columns. The statement will calculate the aggregation of values in the column c4 based on the hierarchy d1 > d2 > d3.

*********************************************************************************************************************************************/

-- CREATE a sales summary table 1st.
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;



-- view the table
-- now we have an aggregate table to group saesl by various items to roll up
SELECT *
FROM [sales].[sales_summary];


-- The following query uses the ROLLUP to calculate the sales amount by brand (subtotal) and both brand and category (total).
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP(brand, category);



--In this example, the query assumes that there is a hierarchy between brand and category, which is the brand > category.
--Note that if you change the order of brand and category, the result will be different as shown in the following query:
SELECT
    category,
    brand,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP (category, brand);




--The following statement shows how to perform a partial roll-up:
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    ROLLUP (category);