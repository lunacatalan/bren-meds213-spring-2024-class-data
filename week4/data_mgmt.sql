-- SQL Triggers in SQLite
CREATE TRIGGER Update_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN -- can add many SQL statements within this
    UPDATE Species
    SET Scientific_name = NULL
    WHERE Code = new.Code AND Scientific_name = ''; 
END;
