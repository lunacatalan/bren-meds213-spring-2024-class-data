-- to open do sqlite3 then .open file_name.sqlite
.table

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

-- PART 1

CREATE TRIGGER egg_filler
    AFTER INSERT ON Bird_eggs
    FOR EACH ROW
    BEGIN
        UPDATE Bird_eggs
        -- count the number of rows that match the nest_id and set that as the egg_num
        SET Egg_num = (SELECT COUNT(*) FROM Bird_eggs WHERE Nest_ID = new.Nest_ID)
        WHERE Nest_ID = new.Nest_ID AND Egg_num IS NULL;
    END;

-- DROP TRIGGER egg_filler; 

-- testing
INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78);

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

-- Part 2

INSERT INTO Bird_eggs
    (Nest_ID, Length, Width)
    VALUES ('14eabaage01', 12.34, 56.78);

SELECT * FROM Bird_nests;
pragma table_info(Bird_nests);

-- DROP TRIGGER egg_filler;

CREATE TRIGGER egg_filler
    AFTER INSERT ON Bird_eggs
    FOR EACH ROW
    BEGIN
        UPDATE Bird_eggs SET Egg_num = (SELECT COUNT(*) FROM Bird_eggs WHERE Nest_ID = new.Nest_ID) 
        WHERE Nest_ID = new.Nest_ID AND Egg_num IS NULL;

        UPDATE Bird_eggs SET Book_page = (SELECT Book_page FROM Bird_nests WHERE Nest_ID = new.Nest_ID);

        UPDATE Bird_eggs SET Year = (SELECT Year FROM Bird_nests WHERE Nest_ID = new.Nest_ID);
        
        UPDATE Bird_eggs SET Site = (SELECT Site FROM Bird_nests WHERE Nest_ID = new.Nest_ID);
    END;

INSERT INTO Bird_eggs
    (Nest_ID, Length, Width)
    VALUES ('14eabaage01', 12.34, 56.78);

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';


-- Week 5 - Create a test harness


