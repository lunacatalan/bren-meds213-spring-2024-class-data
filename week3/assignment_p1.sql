-- Suppose you’re not sure what the AVG function returns if there are NULL values in the column being averaged. 
-- Suppose you either didn’t have access to any documentation, or didn’t trust it. 
-- What experiment could you run to find out what happens?

-- PROBLEM 1: Part 1

-- Create table
CREATE TEMP TABLE p1 (

col1 REAL

);

-- insert values into column
INSERT INTO p1(col1) VALUES(1),(2), (NULL), (23), (28);

-- check if the values added
SELECT * FROM p1;

-- check what happens when applying AVG()
SELECT AVG(col1) FROM p1;

-- The average I got was 11. This means that they ignore NULL values instead of treating it as a 0.
-- There are 6 rows, but 5 numbers that add up to 55, so if AVG() was treating the NULL as 0 then it would be 
-- doing 55/6. Instead, it is doing 55/5 which is 11. This means that it is getting ignored. 


-- PROBLEM 1: Part 2
SELECT SUM(col1)/COUNT(*) FROM p1;
SELECT SUM(col1)/COUNT(col1) FROM p1;

-- The second query is correct because it is asking for the count of the values in col1 instead of asking for
-- all of the columns COUNT(*). The first query asks for all of the rows, which includes the null value and so
-- the denominator would be 6. However, the second query COUNT(col1) returns only the valid values in the 
-- column selected which makes the denominator 5, and returns the correct average. 

DROP TABlE p1; 

-- PROBLEM 2: Part 1

SELECT Site_name, MAX(Area) FROM Site;

-- This gives an error because the query above is trying to ask for the Site_name and MAX(AREA) columns,
-- however, there is no indication of what context MAX() is asking about. This error is solved when you ask for
-- the MAX(Area) and tell it to group by Site_name. This tells it that within the Site_name group, to find 
-- the max area. 

SELECT MAX(Area) FROM Site
    GROUP BY Site_name;


-- PROBLEM 2: Part 2
-- Find the site name and area of the site having the largest area. Do so by ordering the rows in 
-- a particularly convenient order, and using LIMIT to select just the first row.

SELECT Site_name, MAX(Area) FROM Site 
    GROUP BY Site_name
    ORDER BY MAX(-Area)
    LIMIT 1;