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

.tables
-- Week 4
SELECT Species FROM Bird_nests WHERE Site = 'nome';
SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species
    LIMIT 2;


SELECT Scientific_name, Nest_count FROM
    (SELECT Species, COUNT(*) AS Nest_count FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species
    LIMIT 2) JOIN Species ON Species = Code;


-- outer joins
CREATE TEMP TABLE a (cola INTEGER, common INTEGER);
INSERT INTO a VALUES (1, 1), (2, 2), (3, 3);
SELECT * FROM a;

CREATE TEMP TABLE b (common INTEGER, colb INTEGER);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
SELECT * FROM b;

-- inner join
-- get the same things in common
SELECT * FROM a JOIN b USING (common);
SELECT * FROM a INNER JOIN b USING (common);

-- left or right outer join
SELECT * FROM a LEFT JOIN b USING (common);
SELECT * FROM a RIGHT JOIN b USING (common);
SELECT * FROM b LEFT JOIN a USING (common);

-- change null values
.nullvalue -NULL-

-- what species do not have nest data?
SELECT * FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests);

-- using inner join
SELECT Code, Scientific_name, Nest_ID, Species, Year FROM Species
    LEFT JOIN Bird_nests ON Code = Species;

SELECT COUNT(*) FROM Bird_nests WHERE Species = 'ruff';

SELECT Code, Scientific_name, Nest_ID, Species, Year FROM Species
    LEFT JOIN Bird_nests ON Code = Species
    WHERE Nest_ID IS NULL;

-- a gotcha when doing grouping 
SELECT * FROM Bird_eggs LIMIT 3;
-- replicating the rows since there were 3 rows in the egg table
SELECT * FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01';

-- results in just 1 row
SELECT Nest_ID, COUNT(*) -- count how many rows
    from bird_nests join bird_eggs using (nest_id)
    WHERE Nest_ID = '14eabaage01'
    group by nest_id;

-- what if I want another value?
SELECT Nest_ID, COUNT(*), Length -- does not work unless you also group by length
    from bird_nests join bird_eggs using (nest_id)
    WHERE Nest_ID = '14eabaage01'
    group by nest_id;

SELECT Nest_ID, Species, COUNT(*) 
    from bird_nests join bird_eggs using (nest_id)
    WHERE Nest_ID = '14eabaage01'
    group by nest_id, species; -- does not work unless you also group by both of these

-- Views: when you find yourself doing the same query over and over again
        -- an alias
        -- different from a temp table because it is dynamic and will always reflect the most update 
        -- a temp table is stored and if anything from mother table changes it will NOT update
        -- can insert a row only if the database can backtrack 
select * from Camp_assignment;
select year, site, name, start, "end"
    from Camp_assignment join Personnel
    on Observer = abbreviation;

create view v as
    select year, site, name, start, "end"
    from Camp_assignment join Personnel
    on Observer = abbreviation;

select * from v;

-- Set operations: UNION, INTERSECT, EXCEPT

    -- example of union

select book_page, nest_id, egg_num, length, width from bird_eggs;
select book_page, nest_id, egg_num, length*25.4, width*25.4 from bird_eggs
    where book_page = 'b14.6'
    UNION
select book_page, nest_id, egg_num, length, width from bird_eggs 
    where book_page != 'b14.6'; -- this misses anywhere that book_page = null

    -- example of union all: mashes tables together...allows for nonsense 

    -- example of except: which species have no nest data?

select code from species   
    except select distinct species from bird_nests;


-- Week 5
--    can insert data...be explicit!! Much less fragile.
--    Can udate and delete

SELECT * FROM Species;
.maxrows 8
INSERT INTO Species VALUES ('abcd', 'thing', 'name', 'age');
SELECT * FROM Species;

-- explicity label columns
INSERT INTO Species (Common_name, Scientific_name, Code, Relevance)
    VALUES('thing2', 'name', 'efgh', 12);

-- take advantage of default vlaues 
INSERT INTO Species (Common_name, Code) VALUES ('thing3', 'ikls');

-- Update and Delete
UPDATE Species SET Relevance = 'not sure yet' WHERE Relevance IS NULL;
SELECT * FROM Species;
DELETE FROM Species WHERE Relevance = 'not sure yet';
SELECT * FROM Species;

-- Safe delete practice #1
SELECT * FROM Species WHERE Relevance = 'Study species';
-- after confirming which rows you want to delete, then edit the statement
DELETE FROM Species WHERE Relevance = 'Study species';
-- incomplete statement 
-- leave off "DELETE", then add it after visual confirmation

-- Data Management 
COPY Species TO 'species_fixed.csv' (HEADER, DELIMITER ',');

-- To go from csv to table in database
--  1. create empty data table with expectations
--  2. import csv and pass it to the epty table

-- create tabel
CREATE TABLE Snow_cover2 (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR, -- some Null in the data :/
    Location VARCHAR NOT NULL,
    Snow_cover INTEGER CHECK (Snow_cover > -1 AND Snow_cover < 101),
    Observer VARCHAR
);

.tables
SELECT * FROM Snow_cover2;

-- import data from csv
COPY Snow_cover2 FROM '../week4/snow_cover_fixedman_JB.csv' (HEADER, DELIMITER ',');
SELECT * FROM Snow_cover2;