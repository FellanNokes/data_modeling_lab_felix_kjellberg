SET search_path TO Yrkesco;

-- =========================================================
-- FAIL CASES: 1 fail per constraint / rule
-- Varje block använder SAVEPOINT så scriptet fortsätter
-- =========================================================

-- 0) (Förutsätter att dessa finns i din "good" DML)
-- City: '11122'
-- Address id: 1
-- Person id: 1
-- Teacher id: 1
-- Student id: 1
-- Facility id: 1
-- Program id: 1
-- Course 'DE25_101-1' finns
-- Om inte: justera id:n efter din data


-- =========================================================
-- A) PersonSensitiveData.social_security_number format (12 digits)
-- CHECK (social_security_number ~ '^[0-9]{12}$')
-- =========================================================
SAVEPOINT sp_ssn_format_fail;
INSERT INTO "PersonSensitiveData"
(person_id, social_security_number, address_id, email, phone_number, salary)
VALUES
(1, '19900101-1234', 1, 'badssn@test.se', '0701234567', NULL); -- innehåller '-' => FAIL
ROLLBACK TO SAVEPOINT sp_ssn_format_fail;


-- =========================================================
-- B) PersonSensitiveData.phone_number format (10 digits)
-- CHECK (phone_number ~ '^[0-9]{10}$')
-- =========================================================
SAVEPOINT sp_phone_format_fail;
INSERT INTO "PersonSensitiveData"
(person_id, social_security_number, address_id, email, phone_number, salary)
VALUES
(1, '199001011234', 1, 'badphone@test.se', '070-123456', NULL); -- fel format => FAIL
ROLLBACK TO SAVEPOINT sp_phone_format_fail;


-- =========================================================
-- C) Teacher.employment_type enum check
-- CHECK (employment_type IN ('Anställd', 'Konsult'))
-- =========================================================
SAVEPOINT sp_employment_type_fail;
INSERT INTO "Teacher" (person_id, consult_id, employment_type)
VALUES
(1, NULL, 'Intern'); -- inte tillåtet => FAIL
ROLLBACK TO SAVEPOINT sp_employment_type_fail;


-- =========================================================
-- D) Teacher.consult_id MUST be NOT NULL when Konsult
-- CHECK ((employment_type='Konsult' AND consult_id IS NOT NULL) OR ...)
-- =========================================================
SAVEPOINT sp_teacher_konsult_needs_consultid_fail;
INSERT INTO "Teacher" (person_id, consult_id, employment_type)
VALUES
(1, NULL, 'Konsult'); -- consult_id saknas => FAIL
ROLLBACK TO SAVEPOINT sp_teacher_konsult_needs_consultid_fail;


-- =========================================================
-- E) Teacher.consult_id MUST be NULL when Anställd
-- =========================================================
SAVEPOINT sp_teacher_anstalld_must_have_null_consultid_fail;
-- Förutsätter att consult_id 1 finns. Om inte, ändra till en som finns.
INSERT INTO "Teacher" (person_id, consult_id, employment_type)
VALUES
(1, 1, 'Anställd'); -- Anställd men consult_id satt => FAIL
ROLLBACK TO SAVEPOINT sp_teacher_anstalld_must_have_null_consultid_fail;


-- =========================================================
-- F) Course points must equal weeks*5
-- CHECK (points = weeks * 5)
-- =========================================================
SAVEPOINT sp_course_points_weeks_fail;
INSERT INTO "Course"
(course_code, name, points, weeks, short_description, teach_id, standalone)
VALUES
('BAD_0001', 'Broken Course', 31, 6, 'Should fail points constraint', 1, false); -- 31 != 6*5
ROLLBACK TO SAVEPOINT sp_course_points_weeks_fail;


-- =========================================================
-- G) StudentCourse awarded_points >= 0
-- CHECK (awarded_points >= 0)
-- =========================================================
SAVEPOINT sp_awarded_points_negative_fail;
INSERT INTO "StudentCourse"
(course_code, student_id, course_completed, start_date, completion_date, grade, awarded_points)
VALUES
('DE25_101-1', 1, true, '2025-09-01', '2025-10-01', 'G', -5); -- negativ => FAIL
ROLLBACK TO SAVEPOINT sp_awarded_points_negative_fail;


-- =========================================================
-- H) StudentCourse completion_date required when course_completed=true
-- CHECK ((course_completed=true AND completion_date IS NOT NULL) OR ...)
-- =========================================================
SAVEPOINT sp_completed_needs_completion_date_fail;
INSERT INTO "StudentCourse"
(course_code, student_id, course_completed, start_date, completion_date, grade, awarded_points)
VALUES
('DE25_101-1', 1, true, '2025-09-01', NULL, 'G', 0); -- completed men saknar completion_date => FAIL
ROLLBACK TO SAVEPOINT sp_completed_needs_completion_date_fail;


-- =========================================================
-- I) StudentCourse completion_date MUST be NULL when course_completed=false
-- =========================================================
SAVEPOINT sp_not_completed_must_have_null_completion_date_fail;
INSERT INTO "StudentCourse"
(course_code, student_id, course_completed, start_date, completion_date, grade, awarded_points)
VALUES
('DE25_101-1', 1, false, '2025-09-01', '2025-10-01', NULL, 0); -- ej klar men har date => FAIL
ROLLBACK TO SAVEPOINT sp_not_completed_must_have_null_completion_date_fail;


-- =========================================================
-- J) UNIQUE (student_id, course_code) in StudentCourse
-- UNIQUE (student_id, course_code)
-- =========================================================
SAVEPOINT sp_studentcourse_unique_fail;
-- Förutsätter att student 1 redan har DE25_101-1 i din "good" data.
INSERT INTO "StudentCourse"
(course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
('DE25_101-1', 1, true, '2025-09-01', '2025-10-01', 'G'); -- duplicate => FAIL
ROLLBACK TO SAVEPOINT sp_studentcourse_unique_fail;


-- =========================================================
-- K) UNIQUE (program_id, course_code, facility_id) in ProgramCourseFacility
-- UNIQUE (program_id, course_code, facility_id)
-- =========================================================
SAVEPOINT sp_pcf_unique_fail;
-- Förutsätter att (program_id=1, facility_id=1, course_code='DE25_101-1') redan finns.
INSERT INTO "ProgramCourseFacility" (program_id, facility_id, course_code)
VALUES
(1, 1, 'DE25_101-1'); -- duplicate => FAIL
ROLLBACK TO SAVEPOINT sp_pcf_unique_fail;


-- =========================================================
-- L) UNIQUE (course_code, facility_id) in StandaloneCourseFacility
-- UNIQUE (course_code, facility_id)
-- =========================================================
SAVEPOINT sp_standalone_unique_fail;
-- Förutsätter att det redan finns en rad med (course_code='STAND_001', facility_id=1)
INSERT INTO "StandaloneCourseFacility" (course_code, facility_id)
VALUES
('STAND_001', 1); -- duplicate => FAIL
ROLLBACK TO SAVEPOINT sp_standalone_unique_fail;


-- =========================================================
-- M) FK fail example: Address.zip_code must exist in City
-- FOREIGN KEY zip_code references City(zip_code)
-- =========================================================
SAVEPOINT sp_fk_zipcode_fail;
INSERT INTO "Address" (streetname, zip_code)
VALUES
('Nowhere street 1', '99999'); -- city saknas => FK FAIL
ROLLBACK TO SAVEPOINT sp_fk_zipcode_fail;


-- =========================================================
-- N) FK fail example: Program.education_leader_id must exist
-- =========================================================
SAVEPOINT sp_fk_educationleader_fail;
INSERT INTO "Program" (name, short_name, short_description, education_leader_id)
VALUES
('Ghost Program', 'GP', 'Should fail FK', 999999); -- saknas => FK FAIL
ROLLBACK TO SAVEPOINT sp_fk_educationleader_fail;