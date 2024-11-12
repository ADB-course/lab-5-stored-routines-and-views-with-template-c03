-- (i) A Procedure called PROC_LAB5
-- Define the delimiter to allow for multiple statements in the procedure
DELIMITER $$

-- Create the PROC_LAB5 procedure in the classicmodels database
CREATE DEFINER=`student`@`%` PROCEDURE `classicmodels`.`PROC_LAB5`()
BEGIN
    -- Variable declarations
    DECLARE finished INT DEFAULT 0;              -- Flag to indicate when cursor fetching is done
    DECLARE department_info TEXT DEFAULT '';     -- Variable to store the concatenated department average salaries
    DECLARE dept_name VARCHAR(255);               -- Variable to hold the department name fetched from cursor
    DECLARE avg_salary DECIMAL(10, 2);           -- Variable to hold the average salary fetched from cursor
    DECLARE start_time DATETIME DEFAULT NOW();    -- Capture the start time of the procedure execution
    DECLARE end_time DATETIME;                    -- Variable to hold the end time of the procedure execution

    -- Declare a cursor to fetch department names and their average salaries
    DECLARE CURSOR dept_cursor CURSOR FOR
        SELECT d.department_name, AVG(s.salary) AS avg_salary
        FROM departments d
        JOIN employees e ON d.department_id = e.department_id
        JOIN salaries s ON e.employee_id = s.employee_id
        GROUP BY d.department_name;

    -- Handler to set finished flag when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Open the cursor to start fetching data
    OPEN dept_cursor;

    -- Loop to fetch each row from the cursor
    LOOP
        FETCH dept_cursor INTO dept_name, avg_salary;  -- Fetch the next department name and average salary
        IF finished THEN                                -- Check if fetching is complete
            LEAVE LOOP;                                -- Exit the loop if no more rows are available
        END IF;
        -- Concatenate the department name and average salary to the department_info variable
        SET department_info = CONCAT(department_info, dept_name, ': ', FORMAT(avg_salary, 2), CHAR(10));
    END LOOP;

    -- Close the cursor after fetching all data
    CLOSE dept_cursor;

    -- Capture the end time after processing
    SET end_time = NOW();
    
    -- Log the execution details into the procedure_log table
    INSERT INTO procedure_log (procedure_name, execution_time, execution_duration) 
    VALUES ('PROC_LAB5', end_time, TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000);

    -- Return the concatenated department average salaries
    SELECT department_info AS "Department Average Salaries";
END $$

-- Reset the delimiter back to the default
DELIMITER ;

-- (ii) A Function called FUNC_LAB5
-- (i) A Procedure called PROC_LAB5
-- Define the delimiter to allow for multiple statements in the procedure
DELIMITER $$

-- Create the PROC_LAB5 procedure in the classicmodels database
CREATE DEFINER=`student`@`%` PROCEDURE `classicmodels`.`PROC_LAB5`()
BEGIN
    -- Variable declarations
    DECLARE finished INT DEFAULT 0;              -- Flag to indicate when cursor fetching is done
    DECLARE department_info TEXT DEFAULT '';     -- Variable to store the concatenated department average salaries
    DECLARE dept_name VARCHAR(255);               -- Variable to hold the department name fetched from cursor
    DECLARE avg_salary DECIMAL(10, 2);           -- Variable to hold the average salary fetched from cursor
    DECLARE start_time DATETIME DEFAULT NOW();    -- Capture the start time of the procedure execution
    DECLARE end_time DATETIME;                    -- Variable to hold the end time of the procedure execution

    -- Declare a cursor to fetch department names and their average salaries
    DECLARE dept_cursor CURSOR FOR
        SELECT d.department_name, AVG(s.salary) AS avg_salary
        FROM departments d
        JOIN employees e ON d.department_id = e.department_id
        JOIN salaries s ON e.employee_id = s.employee_id
        GROUP BY d.department_name;

    -- Handler to set finished flag when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Open the cursor to start fetching data
    OPEN dept_cursor;

    -- Loop to fetch each row from the cursor
    LOOP
        FETCH dept_cursor INTO dept_name, avg_salary;  -- Fetch the next department name and average salary
        IF finished THEN                                -- Check if fetching is complete
            LEAVE LOOP;                                -- Exit the loop if no more rows are available
        END IF;
        -- Concatenate the department name and average salary to the department_info variable
        SET department_info = CONCAT(department_info, dept_name, ': ', FORMAT(avg_salary, 2), CHAR(10));
    END LOOP;

    -- Close the cursor after fetching all data
    CLOSE dept_cursor;

    -- Capture the end time after processing
    SET end_time = NOW();
    
    -- Log the execution details into the procedure_log table
    INSERT INTO procedure_log (procedure_name, execution_time, execution_duration) 
    VALUES ('PROC_LAB5', end_time, TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000);

    -- Return the concatenated department average salaries
    SELECT department_info AS "Department Average Salaries";
END $$

-- Reset the delimiter back to the default
DELIMITER ;

-- (ii) A Function called FUNC_LAB5
CREATE DEFINER=`student`@`%` FUNCTION `classicmodels`.`FUNC_LAB5`(dept_id INT) 
RETURNS VARCHAR(255)                              -- Function returns a string
DETERMINISTIC                                      -- Function behavior is deterministic (same input yields same output)
BEGIN
    DECLARE total_salary DECIMAL(10, 2);          -- Variable to hold the total salary for the specified department
    
    -- Calculate the total salary for the specified department and store it in total_salary
    SELECT SUM(s.salary) INTO total_salary
    FROM employees e
    JOIN salaries s ON e.employee_id = s.employee_id
    WHERE e.department_id = dept_id;                -- Filter by department ID

    -- Check if total_salary is NULL (i.e., no records found)
    IF total_salary IS NULL THEN
        RETURN 'Invalid department ID or no salaries found.'; -- Return an error message if no salaries found
    END IF;

    --

-- (iii) A View called VIEW_LAB5

DELIMITER //

CREATE DEFINER=`student`@`%` VIEW `classicmodels`.`VIEW_LAB5` AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.department_name,
    es.salary,
    (SELECT MAX(salary) FROM employee_salaries WHERE employee_id IN (SELECT employee_id FROM employees WHERE department_id = e.department_id)) AS max_salary,
    (SELECT MIN(salary) FROM employee_salaries WHERE employee_id IN (SELECT employee_id FROM employees WHERE department_id = e.department_id)) AS min_salary
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    employee_salaries es ON e.employee_id = es.employee_id;

//

DELIMITER ;