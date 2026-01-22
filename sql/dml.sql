SET search_path TO Yrkesco;

-------------------------
-- 1. CITY & ADDRESS
-------------------------
INSERT INTO "City" VALUES
('11122', 'Stockholm'),
('41255', 'Göteborg'),
('90326', 'Umeå');

INSERT INTO "Address" (streetname, zip_code) VALUES
('Studentgatan 1', '11122'), -- 1
('Studentgatan 2', '11122'), -- 2
('Kodvägen 42',   '41255'), -- 3
('Pixelgränd 7',  '90326'); -- 4


-------------------------
-- 2. PERSONS (students + leaders + teachers)
-------------------------
INSERT INTO "Person" (first_name, last_name) VALUES
('Felix',   'Cyberhawk'),   -- 1
('Anja',    'Bugslayer'),   -- 2
('Rikard',  'Nullpointer'), -- 3
('Elvin',   'Ledarsen'),    -- 4 (Education Leader)
('Melvin',  'Planér'),      -- 5 (Education Leader)
('Ada',     'Lovelace'),    -- 6
('Linus',   'Torvalds'),    -- 7
('Neo',     'Matrixson'),   -- 8
('Zelda',   'Bytewind'),    -- 9
('Gandalf', 'Graycode'),    -- 10
('Mario',   'Pipelayer'),   -- 11
('Lara',    'Croftbit'),    -- 12
('Sheldon', 'Cooperand'),   -- 13
('Dexter',  'Algorithm'),   -- 14
-- TEACHERS (extra)
('Kokchun', 'CodeSensei'),  -- 15
('Debbie',  'DataWizard');  -- 16


-------------------------
-- 3. PERSON SENSITIVE DATA
-------------------------
INSERT INTO "PersonSensitiveData"
(person_id, social_security_number, address_id, email, phone_number, salary)
VALUES
(1,  '199301017777', 1, 'felix@student.se', '0701111111', NULL),
(2,  '199702027888', 1, 'anja@student.se',  '0702222222', NULL),
(3,  '198201037999', 2, 'rikard@student.se','0703333333', NULL),
(4,  '198001019999', 3, 'elvin@yrkesco.se', '0704444444', 52000),
(5,  '198502029998', 3, 'melvin@yrkesco.se','0705555555', 46000),
(6,  '200001019111', 4, 'ada@student.se',   '0706666666', NULL),
(7,  '199912129222', 4, 'linus@student.se', '0707777777', NULL),
(8,  '200105059333', 4, 'neo@student.se',   '0708888888', NULL),
(9,  '200203039444', 4, 'zelda@student.se', '0709999999', NULL),
(10, '199811119555', 4, 'gandalf@student.se','0701212121', NULL),
(11, '199910109666', 3, 'mario@student.se','0702323232', NULL),
(12, '200012129777', 3, 'lara@student.se', '0703434343', NULL),
(13, '199905059888', 3, 'sheldon@student.se','0704545454', NULL),
(14, '199806069999', 3, 'dexter@student.se','0705656565', NULL),
(15, '198811117777', 3, 'kokchun@aigineer.se','0709090909', NULL),
(16, '199001017888', 3, 'debbie@aigineer.se','0708080808', NULL);


-------------------------
-- 4. EDUCATION LEADERS
-------------------------
INSERT INTO "EducationLeader" (person_id, hire_date) VALUES
(4, '2020-01-01'),  -- Elvin
(5, '2021-01-01');  -- Melvin


-------------------------
-- 5. ROUNDS
-------------------------
INSERT INTO "Round" (start_year, end_year) VALUES
('2024-09-01', '2026-06-01'), -- 1
('2025-09-01', '2027-06-01'); -- 2


-------------------------
-- 6. CLASSES
-------------------------
INSERT INTO "Class" (name, short_name, round_id) VALUES
('Data Engineer 24',   'DE24', 1),
('Data Engineer 25',   'DE25', 2),
('Game Programming 24','GP24', 1),
('Game Programming 25','GP25', 2),
('AI Developer 24',    'AI24', 1),
('AI Developer 25',    'AI25', 2),
('Web Dev 24',         'WD24', 1),
('Web Dev 25',         'WD25', 2);


-------------------------
-- 7. STUDENTS (person → class)
-------------------------
INSERT INTO "Student" (person_id, class_id) VALUES
(1,  2), (2,  2), (3,  2), (6, 2), (7, 2), -- DE25 (5 st)
(8,  1), (9,  1),                         -- DE24
(10, 3), (11, 3),                         -- GP24
(12, 4), (13, 4),                         -- GP25
(14, 5);                                  -- AI24


-------------------------
-- 8. COMPANIES
-------------------------
INSERT INTO "Company" VALUES
('5566778899', 3, true),  -- Main consulting co
('9988776655', 4, true),
('1122334455', 3, true);  -- AIgineer


-------------------------
-- 9. CONSULTS
-------------------------
INSERT INTO "Consult" (fee, organization_number) VALUES
(1200, '5566778899'), -- id=1
(1100, '5566778899'), -- id=2
(1000, '9988776655'), -- id=3
(1300, '1122334455'), -- id=4 (Kokchun)
(1250, '1122334455'); -- id=5 (Debbie)


-------------------------
-- 10. TEACHERS
-------------------------
INSERT INTO "Teacher" (person_id, consult_id, employment_type) VALUES
(4,  NULL, 'Anställd'), -- Elvin
(5,  NULL, 'Anställd'), -- Melvin
(6,  1,    'Konsult'),  -- Ada → random consultant
(7,  2,    'Konsult'),  -- Linus
(8,  3,    'Konsult'),  -- Neo
(15, 4,    'Konsult'),  -- Kokchun @ AIgineer
(16, 5,    'Konsult');  -- Debbie  @ AIgineer


-------------------------
-- 11. FACILITIES
-------------------------
INSERT INTO "Facility" (name, address_id, start_date) VALUES
('Campus Stockholm', 1, '2020-01-01'),
('Campus Göteborg', 3, '2021-01-01');


-------------------------
-- 12. COURSES
-------------------------
INSERT INTO "Course" VALUES
('DE25_101-1','Python Programming', 30, 6,'Python basics',              (SELECT teacher_id FROM "Teacher" WHERE person_id=15), false),
('DE25_102-2','SQL & Databases',    25, 5,'SQL & DB modeling',          (SELECT teacher_id FROM "Teacher" WHERE person_id=16), false),
('DE25_103-3','Data Modeling',      20, 4,'ER & normalization',         (SELECT teacher_id FROM "Teacher" WHERE person_id=15), false),

('GP25_201-1','Unity Basics',       30, 6,'Unity Engine',               (SELECT teacher_id FROM "Teacher" WHERE person_id=8),  false),
('GP25_202-2','C# for Games',       25, 5,'C# scripting',               (SELECT teacher_id FROM "Teacher" WHERE person_id=8),  false),

('STAND_001','Git Fundamentals',    10, 2,'Version control',            (SELECT teacher_id FROM "Teacher" WHERE person_id=8),  true);


-------------------------
-- 13. PROGRAMS
-------------------------
INSERT INTO "Program" (name, short_name, short_description, education_leader_id) VALUES
('Data Engineer',   'DE', 'Data pipelines & analytics', 1),
('Game Programming','GP', 'Game dev & engines',         1),
('AI Developer',    'AI', 'AI & ML',                    2),
('Web Developer',   'WD', 'Frontend & backend',         2);


-------------------------
-- 14. PROGRAM COURSE FACILITY
-------------------------
INSERT INTO "ProgramCourseFacility" (program_id, facility_id, course_code) VALUES
(1, 1, 'DE25_101-1'),
(1, 1, 'DE25_102-2'),
(1, 1, 'DE25_103-3'),
(2, 2, 'GP25_201-1'),
(2, 2, 'GP25_202-2');


SET search_path TO Yrkesco;

-------------------------------------------------
-- 1) FLER KURSER (så alla klasser har några)
-------------------------------------------------
INSERT INTO "Course" (course_code, name, points, weeks, short_description, teach_id, standalone)
VALUES
-- DE24
('DE24_101-1','Advanced SQL',        25, 5, 'Windows, tuning, CTE',        (SELECT teacher_id FROM "Teacher" WHERE person_id=16), false),
('DE24_102-2','Data Warehousing',    30, 6, 'Star schema, ETL basics',      (SELECT teacher_id FROM "Teacher" WHERE person_id=15), false),

-- GP24
('GP24_101-1','Unity Intermediate',  30, 6, 'Scenes, prefabs, UI',          (SELECT teacher_id FROM "Teacher" WHERE person_id=8 ), false),
('GP24_102-2','C# Patterns',         25, 5, 'OOP + patterns for games',     (SELECT teacher_id FROM "Teacher" WHERE person_id=8 ), false),

-- AI24
('AI24_101-1','Intro to ML',         30, 6, 'Supervised learning basics',   (SELECT teacher_id FROM "Teacher" WHERE person_id=4 ), false),
('AI24_102-2','Math for ML',         25, 5, 'Linear algebra + gradients',   (SELECT teacher_id FROM "Teacher" WHERE person_id=5 ), false),

-- Standalone extras
('STAND_002','Linux Basics',         10, 2, 'Shell, files, permissions',    (SELECT teacher_id FROM "Teacher" WHERE person_id=5 ), true),
('STAND_003','CV & LinkedIn',         5, 1, 'Career branding',              (SELECT teacher_id FROM "Teacher" WHERE person_id=4 ), true)
ON CONFLICT (course_code) DO NOTHING;

-------------------------------------------------
-- 2) STUDENTCOURSE FÖR ALLA ELEVER (1–12)
-- student_id-map (utifrån din INSERT-ordning):
-- 1 Felix, 2 Anja, 3 Rikard, 4 Ada, 5 Linus,
-- 6 Neo, 7 Zelda, 8 Gandalf, 9 Mario,
-- 10 Lara, 11 Sheldon, 12 Dexter
-------------------------------------------------

-- DE25: student_id 1–5
INSERT INTO "StudentCourse" (course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
-- Felix (1) klar allt hittills
('DE25_101-1', 1, true,  '2025-09-01', '2025-10-15', 'VG'),
('DE25_102-2', 1, true,  '2025-10-16', '2025-11-30', 'VG'),
('DE25_103-3', 1, true,  '2025-12-01', '2026-01-10', 'VG'),
('STAND_001',  1, true,  '2025-11-01', '2025-11-14', 'G'),

-- Anja (2) klar allt hittills
('DE25_101-1', 2, true,  '2025-09-01', '2025-10-15', 'VG'),
('DE25_102-2', 2, true,  '2025-10-16', '2025-11-30', 'VG'),
('DE25_103-3', 2, true,  '2025-12-01', '2026-01-10', 'VG'),
('STAND_002',  2, true,  '2025-11-15', '2025-11-28', 'G'),

-- Rikard (3) klar allt hittills
('DE25_101-1', 3, true,  '2025-09-01', '2025-10-15', 'VG'),
('DE25_102-2', 3, true,  '2025-10-16', '2025-11-30', 'VG'),
('DE25_103-3', 3, true,  '2025-12-01', '2026-01-10', 'VG'),
('STAND_003',  3, true,  '2025-12-15', '2025-12-21', 'G'),

-- Ada (4) ligger lite efter (en pågående)
('DE25_101-1', 4, true,  '2025-09-01', '2025-10-20', 'G'),
('DE25_102-2', 4, true,  '2025-10-21', '2025-12-05', 'G'),
('DE25_103-3', 4, false, '2025-12-06', NULL,         NULL),
('STAND_001',  4, true,  '2025-11-01', '2025-11-14', 'G'),

-- Linus (5) ännu mer efter
('DE25_101-1', 5, true,  '2025-09-01', '2025-10-25', 'G'),
('DE25_102-2', 5, false, '2025-10-26', NULL,         NULL),
('STAND_002',  5, true,  '2025-11-15', '2025-11-28', 'G')
ON CONFLICT (student_id, course_code) DO NOTHING;

-- DE24: student_id 6–7
INSERT INTO "StudentCourse" (course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
('DE24_101-1', 6, true,  '2024-09-02', '2024-10-10', 'VG'),
('DE24_102-2', 6, true,  '2024-10-11', '2024-12-05', 'G'),
('STAND_001',  6, true,  '2025-03-01', '2025-03-14', 'G'),

('DE24_101-1', 7, true,  '2024-09-02', '2024-10-10', 'G'),
('DE24_102-2', 7, false, '2024-10-11', NULL,         NULL),
('STAND_003',  7, true,  '2025-04-01', '2025-04-07', 'G')
ON CONFLICT (student_id, course_code) DO NOTHING;

-- GP24: student_id 8–9
INSERT INTO "StudentCourse" (course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
('GP24_101-1', 8, true,  '2024-09-02', '2024-10-15', 'VG'),
('GP24_102-2', 8, true,  '2024-10-16', '2024-12-01', 'G'),
('STAND_002',  8, true,  '2025-02-01', '2025-02-14', 'G'),

('GP24_101-1', 9, true,  '2024-09-02', '2024-10-20', 'G'),
('GP24_102-2', 9, false, '2024-10-21', NULL,         NULL),
('STAND_001',  9, true,  '2025-02-01', '2025-02-14', 'G')
ON CONFLICT (student_id, course_code) DO NOTHING;

-- GP25: student_id 10–11 (du har redan GP25-kurser i Course)
INSERT INTO "StudentCourse" (course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
('GP25_201-1', 10, true,  '2025-09-01', '2025-10-15', 'G'),
('GP25_202-2', 10, false, '2025-10-16', NULL,         NULL),
('STAND_003',  10, true,  '2025-11-01', '2025-11-07', 'G'),

('GP25_201-1', 11, true,  '2025-09-01', '2025-10-15', 'VG'),
('GP25_202-2', 11, true,  '2025-10-16', '2025-12-01', 'G'),
('STAND_001',  11, true,  '2025-11-01', '2025-11-14', 'G')
ON CONFLICT (student_id, course_code) DO NOTHING;

-- AI24: student_id 12
INSERT INTO "StudentCourse" (course_code, student_id, course_completed, start_date, completion_date, grade)
VALUES
('AI24_101-1', 12, true,  '2024-09-02', '2024-10-20', 'VG'),
('AI24_102-2', 12, false, '2024-10-21', NULL,         NULL),
('STAND_002',  12, true,  '2025-01-10', '2025-01-24', 'G')
ON CONFLICT (student_id, course_code) DO NOTHING;