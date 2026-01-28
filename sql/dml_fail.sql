SET search_path TO Yrkesco;

--social_security_number fail due -
SAVEPOINT sp_ssn_format_fail;
INSERT INTO "PersonSensitiveData"
(person_id, social_security_number, address_id, email, phone_number, salary)
VALUES
(1, '19900101-1234', 1, 'badssn@test.se', '0701234567', NULL); -- innehåller '-' => FAIL
ROLLBACK TO SAVEPOINT sp_ssn_format_fail;


-- CHECK (points = weeks * 5)
SAVEPOINT sp_course_points_weeks_fail;
INSERT INTO "Course"
(course_code, name, points, weeks, short_description, teach_id, standalone)
VALUES
('BAD_0001', 'Broken Course', 31, 6, 'Should fail points constraint', 1, false); -- 31 != 6*5
ROLLBACK TO SAVEPOINT sp_course_points_weeks_fail;


-- CHECK (awarded_points >= 0)
SAVEPOINT sp_awarded_points_negative_fail;
INSERT INTO "StudentCourse"
(course_code, student_id, course_completed, start_date, completion_date, grade, awarded_points)
VALUES
('DE25_101-1', 1, true, '2025-09-01', '2025-10-01', 'G', -5); -- negativ => FAIL
ROLLBACK TO SAVEPOINT sp_awarded_points_negative_fail;
