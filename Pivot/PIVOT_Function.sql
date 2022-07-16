


/***************************************************************

PIVOT

Sample database found here: https://www.sqlservertutorial.net/sql-server-sample-database/

****************************************************************/

-- group by category and get  count of products in each category
SELECT 
category_name, 
COUNT(product_id) product_count
FROM production.products p
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY category_name;


-- the objective is to turn the catagory names into columns rather than rows
-- The PIVOT function allows us to do this!
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;





-- Lets add years as rows, this is added in the 1st query
-- Now the table will show 4 rows which represnt a differnt year but it will give us category counts for each one!
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id,
        model_year
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;