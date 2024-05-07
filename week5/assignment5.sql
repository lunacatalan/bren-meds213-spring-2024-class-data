-- to open do sqlite3 then .open file_name.sqlite
.table


-- BASH Essentials
-- 1. The outputs of these three commands are the same. This is because the ls command asks what files and subdirectories are in the week3 folder,
--    and the . directs the question to the current directory. Since we are in the week3 directory, the outputs of those commands are the same. For
--    ls  "$(pwd)/../week3", this is saying print the current working directory, then navigate to the parent directory, and enter the week3 subdirectory,
--    resulting in the same answer as the other two commands. 

-- 2. The cat command displays the combined output of all the csv files (*.csv), and then the | is used as a pipe operator, and it counts the number of lines. 
--    No filenames are shown because the cat *.csv combined all of the csv's so there are no file names by the time the lines are counted.

-- 3. The result is `100 species.csv`. This means it only displays the lines in the species.csv file. Because we specified the filename, it only displayed the
--    the lines from that csv. 

-- 4. You can change the variable name: 
name=Moe
echo $name'_Howard'

-- 5. When running bash myscript.sh *.csv, the variables are the different .csv files. It sees multiple arguments passed to it because its iterating through the 
--     csv files. 

-- 6. bash myscript.sh "$(date)" $(date) The value of variable $3 is the third date variable needed for the script. 

-- 7. When we ran the `sort junk_file.txt > junk_file.txt` it deleted everything in the junk_fil.txt file. 
--      Created a new file junk_fil_2.txt with the sorted output with: sort junk_file.txt > junk_fil_2.txt
--      Then I moved the contents of junk_fil_2.txt to the junk_file.txt by using this command: 
--      mv junk_fil_2.txt ~/Documents/dev/eds213/bren-meds213-spring-2024-class-data/week3/junk_file.txt

-- 8. If there is a space between the * and the .csv, then it will delete everything in the current directly because the * means everything. 

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


-- not_in
SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

bash test_harness.sh not_in 1000 'SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);' \
     database.db part_2_timings.csv

-- outer
SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL;

bash test_harness.sh outer_query 1000 'SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL;' \
     database.db part_2_timings.csv

-- set
SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;

bash test_harness.sh set_query 1000 'SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;' \
     database.db part_2_timings.csv




