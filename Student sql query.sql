DESCRIBE student_grades_db.students;

-- Count of students with GPA < 3, grouped by GPA
SELECT gpa, COUNT(*) AS student_count
FROM student_grades_db.students
WHERE gpa < 3
GROUP BY gpa;

--  average GPA per grade level
WITH avg_gpa AS (
    SELECT 
        grade_level, 
        AVG(gpa) AS average_gpa 
    FROM student_grades_db.students
    GROUP BY grade_level
)
SELECT * 
FROM avg_gpa;

-- count students by range
WITH student_count AS (
    SELECT 
	CASE WHEN gpa < 3 THEN 'Below 3.0'
	     WHEN gpa >= 3 THEN 'Above or equal to 3.0'
        END AS gpa_range,
        COUNT(student_id) AS student_count
    FROM student_grades_db.students
    GROUP BY gpa_range
)
SELECT * 
FROM student_count;


SELECT student_name, gpa
FROM student_grades_db.students
WHERE gpa < (SELECT AVG(gpa) 
FROM student_grades_db.students);

SELECT * FROM student_grades_db.students
WHERE student_name IS NULL;

DELETE FROM student_grades_db.students
WHERE student_id IS NULL;
COMMIT;

SELECT 
    student_grades_db.students.student_id,
    student_grades_db.students.student_name,
    AVG(student_grades_db.students.gpa) AS average_gpa
FROM student_grades_db.students
LEFT JOIN student_grades_db.student_grades 
    ON student_grades_db.students.student_id = student_grades_db.student_grades.student_id
GROUP BY student_grades_db.students.student_id, student_grades_db.students.student_name;

WITH min_final_grade AS (
    SELECT department, 
           class_name, 
           MIN(final_grade) AS min_final_grade
    FROM student_grades_db.student_grades
    GROUP BY department, class_name
)
SELECT * FROM min_final_grade;

WITH max_final_grade AS (SELECT 
department,
class_name,
max(final_grade) AS max_final_grade 
FROM student_grades_db.student_grades
GROUP BY department,class_name)
SELECT * FROM max_final_grade;
-- 
SELECT
    SUM(CASE WHEN school_lunch = 'Yes' THEN 1 ELSE 0 END) AS school_lunch_partakers,
    SUM(CASE WHEN school_lunch = 'No' THEN 1 ELSE 0 END) AS  non_school_lunch
FROM student_grades_db.students;
-- group average grade by student_name
SELECT 
  students.student_name,
  AVG(final_grade) AS average_grade
FROM student_grades_db.student_grades
LEFT JOIN student_grades_db.students 
  ON student_grades.student_id = students.student_id
GROUP BY students.student_name
ORDER BY average_grade desc
limit 5;






