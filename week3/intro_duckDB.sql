-- Monday typescript
--    Lessons:
--      Make sure you are in the correct folder with the database.db file 
--      * means selecting all columns
--      use .tables to see the tables in the database -> if you messed up nothing will show up
--      statements must end in ;
--      to abandon command: `Cntrl + C`
--      to exit duckdb: `.exit` OR `Cntrl + D`
--      syntax for select statement: https://www.sqlite.org/docs.html 

SELECT * FROM Species;
.tables

-- SQL is case insensitive 
select * from species;

-- limiting rows shown
SELECT * FROM Species LIMIT 5;

-- limit rows and select the next 5 rows
SELECT * FROM Species LIMIT 5 OFFSET 5;

-- how many rows?
SELECT COUNT(*) FROM Species;

-- add in column_name to determine how many non null values?
SELECT COUNT(Scientific_name) FROM Species;

-- how many distinct values occur?
SELECT DISTINCT Species FROM Bird_nests;

SELECT Code, Common_name FROM Species;

SELECT Species FROM Bird_nests;

-- get distinct combinations
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- ordering of results...there is no inherent order
--      Order alphabetically:
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;

-- From Site table: what distinct locations occur? Order them, and limit to 3 results
SELECT * FROM Site;
SELECT DISTINCT Location FROM Site ORDER BY Location LIMIT 3;