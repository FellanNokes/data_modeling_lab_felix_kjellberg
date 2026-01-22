SET search_path TO Yrkesco;

\echo '--- 1. Selecting all students from DE25 ---'
SELECT
  s.student_id,
  p.first_name,
  p.last_name,
  c.name AS class_name
FROM "Student" s
JOIN "Person" p ON p.person_id = s.person_id
JOIN "Class" c ON c.class_id = s.class_id
WHERE c.short_name = 'DE25';

\echo '--- 2. Selectng all courses a student is or has read ---'
SELECT
  p.first_name,
  p.last_name,
  sc.course_code,
  c.name AS course_name,
  sc.course_completed,
  sc.awarded_points
FROM "StudentCourse" sc
JOIN "Student" s ON s.student_id = sc.student_id
JOIN "Person" p ON p.person_id = s.person_id
JOIN "Course" c ON c.course_code = sc.course_code
WHERE s.student_id = 1;

\echo '--- 3. total points per student (control if trigger logic worked) ---'
SELECT
  p.first_name,
  p.last_name,
  s.points AS total_points
FROM "Student" s
JOIN "Person" p ON p.person_id = s.person_id
ORDER BY s.points DESC;

\echo '--- 4. Students that are behind (reading course but not finnished) ---'
SELECT DISTINCT
  p.first_name,
  p.last_name
FROM "StudentCourse" sc
JOIN "Student" s ON s.student_id = sc.student_id
JOIN "Person" p ON p.person_id = s.person_id
WHERE sc.course_completed = false;

\echo '--- 5. all courses per program with facility ---'
SELECT
  pr.name AS program_name,
  c.course_code,
  c.name AS course_name,
  f.name AS facility
FROM "ProgramCourseFacility" pcf
JOIN "Program" pr ON pr.program_id = pcf.program_id
JOIN "Course" c ON c.course_code = pcf.course_code
JOIN "Facility" f ON f.facility_id = pcf.facility_id
ORDER BY pr.name;

\echo '--- 6. standalone courses ---'
SELECT
  c.course_code,
  c.name,
  f.name AS facility
FROM "StandaloneCourseFacility" scf
JOIN "Course" c ON c.course_code = scf.course_code
JOIN "Facility" f ON f.facility_id = scf.facility_id;

\echo '--- 7. What courses teachers has ---'
SELECT
  p.first_name,
  p.last_name,
  c.course_code,
  c.name AS course_name
FROM "Teacher" t
JOIN "Person" p ON p.person_id = t.person_id
JOIN "Course" c ON c.teach_id = t.teacher_id
ORDER BY p.last_name;

\echo '--- 8. Consults, Company and which courses they have ---'
SELECT
  p.first_name,
  p.last_name,
  co.organization_number,
  c.name AS course_name
FROM "Teacher" t
JOIN "Person" p ON p.person_id = t.person_id
JOIN "Consult" cn ON cn.consult_id = t.consult_id
JOIN "Company" co ON co.organization_number = cn.organization_number
JOIN "Course" c ON c.teach_id = t.teacher_id
WHERE t.employment_type = 'Konsult';

\echo '--- 9. Education leader and which programs the have ---'
SELECT
  p.first_name,
  p.last_name,
  pr.name AS program_name
FROM "Program" pr
JOIN "EducationLeader" el ON el.education_leader_id = pr.education_leader_id
JOIN "Person" p ON p.person_id = el.person_id;

\echo '--- 10. Students in Stockholm ---'
SELECT
  p.first_name,
  p.last_name,
  c.city
FROM "Student" s
JOIN "Person" p ON p.person_id = s.person_id
JOIN "PersonSensitiveData" psd ON psd.person_id = p.person_id
JOIN "Address" a ON a.address_id = psd.address_id
JOIN "City" c ON c.zip_code = a.zip_code
WHERE c.city = 'Stockholm';
