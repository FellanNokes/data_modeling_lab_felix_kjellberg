SET search_path TO Yrkesco;

--------------------
-- CITY & ADDRESS
--------------------
INSERT INTO "City" VALUES
('11122', 'Stockholm'),
('41255', 'Göteborg'),
('90326', 'Umeå');

INSERT INTO "Address" (streetname, zip_code) VALUES
('Studentgatan 1', '11122'),
('Studentgatan 2', '11122'),
('Kodvägen 42', '41255'),
('Pixelgränd 7', '90326');

--------------------
-- PERSONS
--------------------
INSERT INTO "Person" (first_name, last_name) VALUES
('Felix', 'Cyberhawk'),
('Anja', 'Bugslayer'),
('Rikard', 'Nullpointer'),
('Elvin', 'Ledarsen'),
('Melvin', 'Planér'),
('Ada', 'Lovelace'),
('Linus', 'Torvalds'),
('Neo', 'Matrixson'),
('Zelda', 'Bytewind'),
('Gandalf', 'Graycode'),
('Mario', 'Pipelayer'),
('Lara', 'Croftbit'),
('Sheldon', 'Cooperand'),
('Dexter', 'Algorithm');

--------------------
-- PERSON SENSITIVE DATA
--------------------
INSERT INTO "PersonSensitiveData"
(person_id, social_security_number, address_id, email, phone_number, salary)
VALUES
(1, '199301017777', 1, 'felix@student.se', '0701111111', NULL),
(2, '199702027888', 1, 'anja@student.se', '0702222222', NULL),
(3, '198201037999', 2, 'rikard@student.se', '0703333333', NULL),
(4, '198001019999', 3, 'elvin@yrkesco.se', '0704444444', 52000),
(5, '198502029998', 3, 'melvin@yrkesco.se', '0705555555', 46000),
(6, '200001019111', 4, 'ada@student.se', '0706666666', NULL),
(7, '199912129222', 4, 'linus@student.se', '0707777777', NULL),
(8, '200105059333', 4, 'neo@student.se', '0708888888', NULL),
(9, '200203039444', 4, 'zelda@student.se', '0709999999', NULL),
(10, '199811119555', 4, 'gandalf@student.se', '0701212121', NULL),
(11, '199910109666', 3, 'mario@student.se', '0702323232', NULL),
(12, '200012129777', 3, 'lara@student.se', '0703434343', NULL),
(13, '199905059888', 3, 'sheldon@student.se', '0704545454', NULL),
(14, '199806069999', 3, 'dexter@student.se', '0705656565', NULL);

--------------------
-- EDUCATION LEADERS
--------------------
INSERT INTO "EducationLeader" (person_id, hire_date) VALUES
(4, '2020-01-01'),
(5, '2021-01-01');

--------------------
-- ROUND
--------------------
INSERT INTO "Round" (start_year, end_year) VALUES
('2024-09-01', '2026-06-01'),
('2025-09-01', '2027-06-01');

--------------------
-- CLASSES
--------------------
INSERT INTO "Class" (name, short_name, round_id) VALUES
('Data Engineer 24', 'DE24', 1),
('Data Engineer 25', 'DE25', 2),
('Game Programming 24', 'GP24', 1),
('Game Programming 25', 'GP25', 2),
('AI Developer 24', 'AI24', 1),
('AI Developer 25', 'AI25', 2),
('Web Dev 24', 'WD24', 1),
('Web Dev 25', 'WD25', 2);

--------------------
-- STUDENTS
--------------------
INSERT INTO "Student" (person_id, class_id) VALUES
(1, 2), (2, 2), (3, 2), (6, 2), (7, 2), -- DE25 (5 st)
(8, 1), (9, 1),                       -- DE24
(10, 3), (11, 3),                     -- GP24
(12, 4), (13, 4),                     -- GP25
(14, 5);                              -- AI24

--------------------
-- COMPANY & CONSULT
--------------------
INSERT INTO "Company" VALUES
('5566778899', 3, true),
('9988776655', 4, true);

INSERT INTO "Consult" (fee, organization_number) VALUES
(1200, '5566778899'),
(1100, '5566778899'),
(1000, '9988776655');

--------------------
-- TEACHERS
--------------------
INSERT INTO "Teacher" (person_id, consult_id, employment_type) VALUES
(4, NULL, 'Anställd'),
(5, NULL, 'Anställd'),
(6, 1, 'Konsult'),
(7, 2, 'Konsult'),
(8, 3, 'Konsult');

--------------------
-- FACILITY
--------------------
INSERT INTO "Facility" (name, address_id, start_date) VALUES
('Campus Stockholm', 1, '2020-01-01'),
('Campus Göteborg', 3, '2021-01-01');

--------------------
-- COURSES
--------------------
INSERT INTO "Course" VALUES
('DE25_101-1', 'Python Programming', 30, 6, 'Python basics', 3, false),
('DE25_102-2', 'SQL & Databases', 25, 5, 'SQL & DB modeling', 4, false),
('DE25_103-3', 'Data Modeling', 20, 4, 'ER & normalization', 3, false),
('GP25_201-1', 'Unity Basics', 30, 6, 'Unity Engine', 5, false),
('GP25_202-2', 'C# for Games', 25, 5, 'C# scripting', 5, false),
('STAND_001', 'Git Fundamentals', 10, 2, 'Version control', 5, true);

--------------------
-- PROGRAM
--------------------
INSERT INTO "Program" (name, short_name, short_description, education_leader_id) VALUES
('Data Engineer', 'DE', 'Data pipelines & analytics', 1),
('Game Programming', 'GP', 'Game dev & engines', 1),
('AI Developer', 'AI', 'AI & ML', 2),
('Web Developer', 'WD', 'Frontend & backend', 2);

--------------------
-- PROGRAM COURSE FACILITY
--------------------
INSERT INTO "ProgramCourseFacility" (program_id, facility_id, course_code) VALUES
(1, 1, 'DE25_101-1'),
(1, 1, 'DE25_102-2'),
(1, 1, 'DE25_103-3'),
(2, 2, 'GP25_201-1'),
(2, 2, 'GP25_202-2');

--------------------
-- COMPANY: AIgineer
--------------------
INSERT INTO "Company" (organization_number, address_id, f_tax)
VALUES ('1122334455', 3, true);

--------------------
-- CONSULTS (AIgineer)
--------------------
INSERT INTO "Consult" (fee, organization_number)
VALUES
(1300, '1122334455'),
(1250, '1122334455');

--------------------
-- PERSONS: Debbie & Kokchun
--------------------
INSERT INTO "Person" (first_name, last_name)
VALUES
('Kokchun', 'CodeSensei'),
('Debbie', 'DataWizard');

--------------------
-- PERSON SENSITIVE DATA
--------------------
INSERT INTO "PersonSensitiveData"
(person_id, social_security_number, address_id, email, phone_number, salary)
VALUES
(currval(pg_get_serial_sequence('"Person"', 'person_id')) - 1,
 '198811117777', 3, 'kokchun@aigineer.se', '0709090909', NULL),

(currval(pg_get_serial_sequence('"Person"', 'person_id')),
 '199001017888', 3, 'debbie@aigineer.se', '0708080808', NULL);

--------------------
-- TEACHERS
--------------------
INSERT INTO "Teacher" (person_id, consult_id, employment_type)
VALUES
(currval(pg_get_serial_sequence('"Person"', 'person_id')) - 1, 4, 'Konsult'),
(currval(pg_get_serial_sequence('"Person"', 'person_id')),     5, 'Konsult');

--------------------
-- UPDATE DE COURSES → assign Kokchun & Debbie
--------------------
UPDATE "Course"
SET teach_id = (
  SELECT teacher_id FROM "Teacher"
  JOIN "Person" USING (person_id)
  WHERE first_name = 'Kokchun'
)
WHERE course_code IN ('DE25_101-1', 'DE25_103-3');

UPDATE "Course"
SET teach_id = (
  SELECT teacher_id FROM "Teacher"
  JOIN "Person" USING (person_id)
  WHERE first_name = 'Debbie'
)
WHERE course_code = 'DE25_102-2';

--------------------
-- STUDENT COURSE (completed → trigger fires)
--------------------
INSERT INTO "StudentCourse"
(course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
('DE25_101-1', 1, true, '2025-09-01', '2025-10-15', 'VG'),
('DE25_102-2', 1, true, '2025-10-16', '2025-11-30', 'VG'),
('DE25_103-3', 1, true, '2025-12-01', '2026-01-10', 'G');


