-- Monday 4/15 typescript
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

-- Wednesday 4/17 transcript
--      Lessons:
--          use .read FILE to access files from other locations 
--          think of this like a CALCULATOR...all operations are momentary
--          If you are indenting you have to HIGHLIGHT everything before running the command

.maxrow 6
SELECT Location FROM Site;
SELECT * FROM Site WHERE Area < 200;

-- pattern recognition
SELECT * FROM SITE WHERE AREA < 200 AND Location LIKE '%USA';

-- expressions 
SELECT Site_name, Area FROM Site;
SELECT Site_name, Area*2.47 FROM Site;

-- to make column and rename
SELECT Site_name, Area*2.247 AS Area_acres FROM Site;

-- string concatination...add 'foo' to the end of the 
SELECT Site_name || 'foo' FROM Site;

-- aggregation functions to access number of rows
SELECT COUNT(*) FROM Site;
SELECT COUNT(*) AS num_rows FROM Site;
SELECT COUNT(Scientific_name) FROM Species;

-- distinct values
SELECT DISTINCT Relevance FROM Species;
-- disctinct counts of that query
SELECT COUNT(DISTINCT Relevance) FROM Species;

-- MIN, MAX, AVG
SELECT AVG(Area) FROM Site;

-- grouping 
SELECT * FROM Site;
SELECT Location, MAX(Area) FROM Site GROUP BY Location;
SELECT Location, COUNT(*) FROM Site GROUP BY Location;

SELECT * FROM Species;

-- how many species are in each of these "Relevance" values
-- * will just count rows, and will count the NULL values
SELECT Relevance, COUNT(*) FROM Species GROUP BY Relevance;
-- this will only return non NULL values
SELECT Relevance, COUNT(Scientific_name) 
    FROM Species 
    GROUP BY Relevance;

SELECT Location, MAX(Area) AS Max_area
    FROM Site 
    WHERE Location 
    LIKE '%Canada' 
    GROUP BY Location
    HAVING Max_area > 200;

-- Relational algebra peeks through:
--      Query returns a TABLE:
SELECT COUNT(*) FROM Site;
--      See how many rows were created from our query above:
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Site);

-- Are there any species where there is no bird_nest data?
SELECT * FROM Bird_nests LIMIT 3;
-- Look at species where the code DOES NOT match the codes from bird_nest data
SELECT * FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests);


-- Saving Queries temporarily using `TEMP`
CREATE TEMP TABLE t AS
    SELECT * FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests);
-- Now we can call the table we just created
SELECT * from t;

-- Saving Queries permanently 
CREATE TABLE t_perm AS
    SELECT * FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests);
-- Now we can call the table we just created
SELECT * from t_perm;
-- to remove from database.db
DROP TABLE t_perm;

-- NULL processing : nulls represent the absence of data / unknown
--      When asking something explicitly, the TRI-VALUE logic will assing nulls to NULL
--      Will only return the rows that are TRUE
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge >5;

SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge <=5;
--      This returns all rows regardless of null values
SELECT COUNT(*) FROM Bird_nests;
--      This does not return anything
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge = NULL;
--      Returns the true values of null
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge IS NULL;

-- Joins!
SELECT * FROM Camp_assignment;
SELECT * FROM Personnel;
-- link using the foreign key
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation; -- foreign key
-- select only these columns...End has to be in quotes because its a reserved word in duckdb
SELECT Name, Year, Site, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 3;

SELECT * FROM Camp_assignment JOIN Personnel
    ON Camp_assignment.Observer = Personnel.Abbreviation;

-- rename the column names
SELECT * FROM Camp_assignment AS ca JOIN Personnel AS p
    ON ca.Observer = p.Abbreviation;

-- Multi-way joins 
SELECT * FROM Camp_assignment AS ca JOIN Personnel AS p 
    ON ca.Observer = p.Abbreviation
    JOIN Site AS s
    ON ca.Site = s.Code -- foreign key
    LIMIT 3;

SELECT * FROM Camp_assignment AS ca JOIN Personnel AS p 
    ON ca.Observer = p.Abbreviation
    JOIN Site AS s
    ON ca.Site = s.Code -- foreign key
    WHERE ca.Observer = 'lmckinnon'
    LIMIT 3;

SELECT * FROM Camp_assignment AS ca JOIN (
    SELECT * FROM Personnel ORDER BY Abbreviation
    ) p
    ON ca.Observer = p.Abbreviation
    JOIN Site AS s
    ON ca.Site = s.Code -- foreign key
    WHERE ca.Observer = 'lmckinnon'
    LIMIT 3;

-- grouping 
SELECT Nest_ID, COUNT(*) FROM Bird_eggs
    GROUP BY Nest_ID;