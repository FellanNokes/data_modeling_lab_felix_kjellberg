CREATE SCHEMA IF NOT EXISTS yrkesco;
SET search_path TO yrkesco;

CREATE TABLE "Person" (
  "person_id" int PRIMARY KEY,
  "first_name" varchar(30) NOT NULL,
  "last_name" varchar(50) NOT NULL
);

CREATE TABLE "PersonSensitiveData" (
  "person_id" int PRIMARY KEY,
  "social_security_number" varchar(12) NOT NULL,
  "address_id" int NOT NULL,
  "email" varchar(100) NOT NULL,
  "phone_number" varchar(10) NOT NULL,
  "salary" float
);

CREATE TABLE "Address" (
  "address_id" int PRIMARY KEY,
  "streetname" varchar(80) NOT NULL,
  "zip_code" varchar(5) NOT NULL
);

CREATE TABLE "City" (
  "zip_code" varchar(5) PRIMARY KEY,
  "city" varchar(50)
);

CREATE TABLE "EducationLeader" (
  "education_leader_id" int PRIMARY KEY,
  "person_id" int NOT NULL,
  "hire_date" date NOT NULL
);

CREATE TABLE "Student" (
  "student_id" int PRIMARY KEY,
  "person_id" int NOT NULL,
  "class_id" int,
  "points" int NOT NULL DEFAULT 0,
  "is_active" boolean NOT NULL
);

CREATE TABLE "Teacher" (
  "teacher_id" int PRIMARY KEY, 
  "person_id" int NOT NULL,
  "consult_id" int,
  "employment_type" VARCHAR(20) Check "Anställd" or "Konsult"
);

CREATE TABLE "Consult" (
  "consult_id" int PRIMARY KEY,
  "fee" float NOT NULL,
  "organization_number" varchar(10) NOT NULL
);

CREATE TABLE "Company" (
  "organization_number" varchar(10) PRIMARY KEY,
  "address_id" int NOT NULL,
  "f_tax" boolean NOT NULL
);

CREATE TABLE "Class" (
  "class_id" int PRIMARY KEY,
  "name" varchar(45) NOT NULL,
  "short_name" varchar(4) NOT NULL,
  "round_id" int NOT NULL
);

CREATE TABLE "Round" (
  "round_id" int PRIMARY KEY,
  "start_year" date year NOT NULL,
  "end_year" date year NOT NULL
);

CREATE TABLE "ProgramRound" (
  "program_round_id" int PRIMARY KEY,
  "round_id" int NOT NULL,
  "program_id" int NOT NULL
);

CREATE TABLE "Program" (
  "program_id" int PRIMARY KEY,
  "name" varchar(40) NOT NULL,
  "short_name" varchar(2) NOT NULL,
  "short_description" varchar(255) NOT NULL,
  "education_leader_id" int NOT NULL
);

CREATE TABLE "Facility" (
  "facility_id" int PRIMARY KEY,
  "name" varchar(60) NOT NULL,
  "address_id" int NOT NULL,
  "start_date" date NOT NULL
);

CREATE TABLE "Course" (
  "course_code" varchar(10) PRIMARY KEY,
  "name" varchar(50) NOT NULL,
  "points" int NOT NULL,
  "weeks" int NOT NULL,
  "short_description" varchar(255) NOT NULL,
  "teach_id" int NOT NULL,
  "standalone" boolean NOT NULL
);

CREATE TABLE "ProgramCourseFacility" (
  "program_course_id" int PRIMARY KEY,
  "program_id" int NOT NULL,
  "facility_id" int NOT NULL,
  "course_code" varchar(10) NOT NULL
);

CREATE TABLE "StudentCourse" (
  "student_course_id" int PRIMARY KEY,
  "course_code" varchar(10) NOT NULL,
  "student_id" int NOT NULL,
  "course_completed" boolean NOT NULL DEFAULT false,
  "start_date" date NOT NULL,
  "completion_date" date,
  "grade" VARCHAR(2),
  "awarded_points" int
);

CREATE TABLE "StandaloneCourseFacility" (
  "standalone_course_id" int PRIMARY KEY,
  "course_code" varchar(10) NOT NULL,
  "facility_id" int NOT NULL
);

COMMENT ON COLUMN "Student"."points" IS 'Student.points är ett härlett värde som uppdateras via trigger när course_completed sätts till true i StudentCourse.';

COMMENT ON COLUMN "Teacher"."consult_id" IS 'TODO: add restraint Check:konsult then not null, Antsälld null';

COMMENT ON COLUMN "Teacher"."employment_type" IS 'add check for type Anställd or Konsult';

COMMENT ON COLUMN "Program"."education_leader_id" IS 'Education leader can have a max of 2 programs';

COMMENT ON TABLE "ProgramCourseFacility" IS 'UNIQUE (program_id, course_code, facility_id)';

COMMENT ON TABLE "StudentCourse" IS 'UNIQUE(student_id, course_code';

COMMENT ON TABLE "StandaloneCourseFacility" IS 'UNIQUE (course_code, facility_id), This table exist so we dont have to mix in program with standalone courses';

ALTER TABLE "PersonSensitiveData" ADD FOREIGN KEY ("person_id") REFERENCES "Person" ("person_id");

ALTER TABLE "PersonSensitiveData" ADD FOREIGN KEY ("address_id") REFERENCES "Address" ("address_id");

ALTER TABLE "Address" ADD FOREIGN KEY ("zip_code") REFERENCES "City" ("zip_code");

ALTER TABLE "EducationLeader" ADD FOREIGN KEY ("person_id") REFERENCES "Person" ("person_id");

ALTER TABLE "Student" ADD FOREIGN KEY ("person_id") REFERENCES "Person" ("person_id");

ALTER TABLE "Student" ADD FOREIGN KEY ("class_id") REFERENCES "Class" ("class_id");

ALTER TABLE "Teacher" ADD FOREIGN KEY ("person_id") REFERENCES "Person" ("person_id");

ALTER TABLE "Teacher" ADD FOREIGN KEY ("consult_id") REFERENCES "Consult" ("consult_id");

ALTER TABLE "Consult" ADD FOREIGN KEY ("organization_number") REFERENCES "Company" ("organization_number");

ALTER TABLE "Company" ADD FOREIGN KEY ("address_id") REFERENCES "Address" ("address_id");

ALTER TABLE "Class" ADD FOREIGN KEY ("round_id") REFERENCES "Round" ("round_id");

ALTER TABLE "ProgramRound" ADD FOREIGN KEY ("round_id") REFERENCES "Round" ("round_id");

ALTER TABLE "ProgramRound" ADD FOREIGN KEY ("program_id") REFERENCES "Program" ("program_id");

ALTER TABLE "Program" ADD FOREIGN KEY ("education_leader_id") REFERENCES "EducationLeader" ("education_leader_id");

ALTER TABLE "Facility" ADD FOREIGN KEY ("address_id") REFERENCES "Address" ("address_id");

ALTER TABLE "Course" ADD FOREIGN KEY ("teach_id") REFERENCES "Teacher" ("teacher_id");

ALTER TABLE "ProgramCourseFacility" ADD FOREIGN KEY ("program_id") REFERENCES "Program" ("program_id");

ALTER TABLE "ProgramCourseFacility" ADD FOREIGN KEY ("facility_id") REFERENCES "Facility" ("facility_id");

ALTER TABLE "ProgramCourseFacility" ADD FOREIGN KEY ("course_code") REFERENCES "Course" ("course_code");

ALTER TABLE "StudentCourse" ADD FOREIGN KEY ("course_code") REFERENCES "Course" ("course_code");

ALTER TABLE "StudentCourse" ADD FOREIGN KEY ("student_id") REFERENCES "Student" ("student_id");

ALTER TABLE "StandaloneCourseFacility" ADD FOREIGN KEY ("course_code") REFERENCES "Course" ("course_code");

ALTER TABLE "StandaloneCourseFacility" ADD FOREIGN KEY ("facility_id") REFERENCES "Facility" ("facility_id");
