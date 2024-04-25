-- Which sites have no egg data? 
-- Please answer this question using all three techniques 
-- demonstrated in class. In doing so, you will need to work 
-- with the Bird_eggs table, the Site table, or both. 
-- As a reminder, the techniques are:

.tables
SELECT * FROM Site;
SELECT * FROM Bird_eggs;

-- Technique 1: Using NOT IN clause
SELECT Code FROM Site
    WHERE Code NOT IN (SELECT Site FROM Bird_eggs);

-- Technique 2: Using outer join with a WHERE
SELECT Code FROM Site 
    LEFT JOIN Bird_eggs ON Code = Site
    WHERE Egg_num IS NULL;

-- Technique 3: using EXCEPT
SELECT Code FROM Site
    EXCEPT SELECT Site from Bird_eggs;

-- The Camp_assignment table lists where each person worked and when. 
-- Your goal is to answer, Who worked with whom? That is, you are to find 
-- all pairs of people who worked at the same site, and whose date ranges overlap
-- while at that site. This can be solved using a self-join. 
-- A self-join of a table is a regular join, but instead of joining two different 
-- tables, we join two copies of the same table, which we will call the “A” copy 
-- and the “B” copy:

CREATE TABLE A AS SELECT * FROM Camp_assignment;
CREATE TABLE B AS SELECT * FROM Camp_assignment;

SELECT * FROM B;

SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2 
    FROM A JOIN B
    ON A.site = B.site AND 
    (A.start <= B.end) AND (A.end >= B.start)
    AND A.Observer < B.Observer
    WHERE A.Site = 'lkri';
    
-- That is, looking at nest data for “nome” between 1998 and 2008 inclusive, 
-- and for which egg age was determined by floating, can you determine the name 
-- of the observer who observed exactly 36 nests? Please submit your SQL. 
-- Your SQL should return exactly one row, the answer. That is, your query should produce:

SELECT * FROM Bird_nests;
SELECT * FROM Personnel;
DESCRIBE Bird_nests;

CREATE TEMP TABLE float_num AS
SELECT Observer, COUNT(*) AS Num_floated_nests FROM Bird_nests
    WHERE Site = 'nome' AND (Year >= 1998 AND YEAR <= 2008) AND (ageMethod = 'float')
    GROUP BY Observer
    HAVING Num_floated_nests = 36;

SELECT Name, Num_floated_nests FROM float_num
    LEFT JOIN Personnel ON Observer = Abbreviation;
