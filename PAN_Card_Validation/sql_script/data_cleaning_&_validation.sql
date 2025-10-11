--- PAN Number Validation Project using SQL ---

create table stg_pan_numbers_dataset
(
	pan_number 		text
);

SELECT * FROM stg_pan_numbers_dataset;

--- Identify and handle missing data ---

SELECT * FROM stg_pan_numbers_dataset WHERE pan_number is NULL;

---  Check for duplicates ---

SELECT 
	pan_number, 
	COUNT(1)
FROM stg_pan_numbers_dataset
GROUP BY pan_number
HAVING COUNT(1) > 1;

--- Handle leading/trailing spaces ---

SELECT * FROM stg_pan_numbers_dataset
WHERE pan_number <> TRIM(pan_number);

--- Correct letter case ---

SELECT * FROM stg_pan_numbers_dataset
WHERE pan_number <> UPPER(pan_number);

--- Cleaned PAN numbers ---

SELECT DISTINCT UPPER(TRIM(pan_number)) AS pan_number
FROM stg_pan_numbers_dataset 
WHERE pan_number is NOT NULL
AND TRIM(pan_number) <> '';

--- Function to check if adjacent characters are the same ---

create or replace function fn_check_adjacent_characters(p_str text)
returns boolean
language plpgsql
as $$
begin
	for i in 1 .. (length(p_str) - 1)
	loop
		if substring(p_str, i, 1) = substring(p_str, i+1, 1)
		then
			return true; --- the characters are adjacent
		end if;
	end loop;
	return false; --- non adjacent characters
end;
$$








