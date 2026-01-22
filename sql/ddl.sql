CREATE SCHEMA IF NOT EXISTS Yrkesco;
SET search_path TO Yrkesco;

CREATE TABLE IF NOT EXISTS "Person" (
  "person_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "first_name" varchar(30) NOT NULL,
  "last_name" varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS "City" (
  "zip_code" varchar(5) PRIMARY KEY,
  "city" varchar(50)
);

CREATE TABLE IF NOT EXISTS "Address" (
  "address_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "streetname" varchar(80) NOT NULL,
  "zip_code" varchar(5) NOT NULL REFERENCES "City"("zip_code")
);

CREATE TABLE IF NOT EXISTS "PersonSensitiveData" (
  "person_id" int PRIMARY KEY REFERENCES "Person"("person_id"),
  "social_security_number" varchar(12) NOT NULL,
  "address_id" int NOT NULL REFERENCES "Address"("address_id"),
  "email" varchar(100) NOT NULL,
  "phone_number" varchar(10) NOT NULL,
  "salary" float,
  CHECK (social_security_number ~ '^[0-9]{12}$'),
  CHECK (phone_number ~ '^[0-9]{10}$')
);

CREATE TABLE IF NOT EXISTS "EducationLeader" (
  "education_leader_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "person_id" int NOT NULL REFERENCES "Person"("person_id"),
  "hire_date" date NOT NULL
);

CREATE TABLE IF NOT EXISTS "Round" (
  "round_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "start_year" date NOT NULL,
  "end_year" date NOT NULL
);

CREATE TABLE IF NOT EXISTS "Class" (
  "class_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "name" varchar(45) NOT NULL,
  "short_name" varchar(4) NOT NULL,
  "round_id" int NOT NULL REFERENCES "Round"("round_id")
);

CREATE TABLE IF NOT EXISTS "Student" (
  "student_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "person_id" int NOT NULL REFERENCES "Person"("person_id"),
  "class_id" int REFERENCES "Class"("class_id"),
  "points" int NOT NULL DEFAULT 0,
  "is_active" boolean NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS "Company" (
  "organization_number" varchar(10) PRIMARY KEY,
  "address_id" int NOT NULL REFERENCES "Address"("address_id"),
  "f_tax" boolean NOT NULL
);

CREATE TABLE IF NOT EXISTS "Consult" (
  "consult_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "fee" float NOT NULL,
  "organization_number" varchar(10) NOT NULL REFERENCES "Company"("organization_number")
);

CREATE TABLE IF NOT EXISTS "Teacher" (
  "teacher_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "person_id" int NOT NULL REFERENCES "Person"("person_id"),
  "consult_id" int REFERENCES "Consult"("consult_id"),
  "employment_type" varchar(20),
  CHECK (employment_type IN ('Anställd', 'Konsult')),

  CHECK (
    (employment_type = 'Konsult' AND consult_id IS NOT NULL)
    OR
    (employment_type = 'Anställd' AND consult_id IS NULL)
  )
);

CREATE TABLE IF NOT EXISTS "Program" (
  "program_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "name" varchar(40) NOT NULL,
  "short_name" varchar(2) NOT NULL,
  "short_description" varchar(255) NOT NULL,
  "education_leader_id" int NOT NULL REFERENCES "EducationLeader"("education_leader_id")
);

CREATE TABLE IF NOT EXISTS "ProgramRound" (
  "program_round_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "round_id" int NOT NULL REFERENCES "Round"("round_id"),
  "program_id" int NOT NULL REFERENCES "Program"("program_id")
);

CREATE TABLE IF NOT EXISTS "Facility" (
  "facility_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "name" varchar(60) NOT NULL,
  "address_id" int NOT NULL REFERENCES "Address"("address_id"),
  "start_date" date NOT NULL
);

CREATE TABLE IF NOT EXISTS "Course" (
  "course_code" varchar(10) PRIMARY KEY,
  "name" varchar(50) NOT NULL,
  "points" int NOT NULL,
  "weeks" int NOT NULL,
  "short_description" varchar(255) NOT NULL,
  "teach_id" int NOT NULL REFERENCES "Teacher"("teacher_id"),
  "standalone" boolean NOT NULL,
  CHECK (points = weeks * 5)
);

CREATE TABLE IF NOT EXISTS "ProgramCourseFacility" (
  "program_course_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "program_id" int NOT NULL REFERENCES "Program"("program_id"),
  "facility_id" int NOT NULL REFERENCES "Facility"("facility_id"),
  "course_code" varchar(10) NOT NULL REFERENCES "Course"("course_code"),
  UNIQUE (program_id, course_code, facility_id)
);

CREATE TABLE IF NOT EXISTS "StudentCourse" (
  "student_course_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "course_code" varchar(10) NOT NULL REFERENCES "Course"("course_code"),
  "student_id" int NOT NULL REFERENCES "Student"("student_id"),
  "course_completed" boolean NOT NULL DEFAULT false,
  "start_date" date NOT NULL,
  "completion_date" date,
  "grade" varchar(2),
  "awarded_points" int NOT NULL DEFAULT 0,
  CHECK (awarded_points >= 0),
  UNIQUE (student_id, course_code),
  CHECK (
    (course_completed = false AND completion_date IS NULL)
    OR
    (course_completed = true AND completion_date IS NOT NULL)
  )
);

CREATE TABLE IF NOT EXISTS "StandaloneCourseFacility" (
  "standalone_course_id" int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "course_code" varchar(10) NOT NULL REFERENCES "Course"("course_code"),
  "facility_id" int NOT NULL REFERENCES "Facility"("facility_id"),
  UNIQUE (course_code, facility_id)
);

COMMENT ON COLUMN "Student"."points" IS 'Student.points är ett härlett värde som uppdateras via trigger när course_completed sätts till true i StudentCourse.';

COMMENT ON COLUMN "Teacher"."consult_id" IS 'TODO: add restraint Check:konsult then not null, Antsälld null';

COMMENT ON COLUMN "Teacher"."employment_type" IS 'add check for type Anställd or Konsult';

COMMENT ON COLUMN "Program"."education_leader_id" IS 'Education leader can have a max of 2 programs';

COMMENT ON TABLE "ProgramCourseFacility" IS 'UNIQUE (program_id, course_code, facility_id)';

COMMENT ON TABLE "StudentCourse" IS 'UNIQUE(student_id, course_code)';

COMMENT ON TABLE "StandaloneCourseFacility" IS 'UNIQUE (course_code, facility_id), This table exist so we dont have to mix in program with standalone courses';


/* Function för award points i student course */
CREATE OR REPLACE FUNCTION award_student_points()
RETURNS TRIGGER AS $$
DECLARE
  course_points INT;
BEGIN
  -- hämta poäng från kurs
  SELECT c.points
  INTO course_points
  FROM "Course" c
  WHERE c.course_code = NEW.course_code;

  IF course_points IS NULL THEN
    RAISE EXCEPTION 'Ingen poäng hittades för kurs %', NEW.course_code;
  END IF;

  -- skydd: ge inte poäng om awarded_points redan satts
  IF COALESCE(NEW.awarded_points, 0) > 0 THEN
    RETURN NEW;
  END IF;

  -- 1) sätt awarded_points i StudentCourse (måste vara UPDATE eftersom vi är AFTER-trigger)
  UPDATE "StudentCourse"
  SET awarded_points = course_points
  WHERE student_course_id = NEW.student_course_id;

  -- 2) uppdatera studentens totalpoäng + active
  UPDATE "Student"
  SET points = points + course_points,
      is_active = TRUE
  WHERE student_id = NEW.student_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


/* Trigger for award student points */
DROP TRIGGER IF EXISTS trg_award_points_insert ON "StudentCourse";
DROP TRIGGER IF EXISTS trg_award_points_update ON "StudentCourse";

CREATE TRIGGER trg_award_points_insert
AFTER INSERT ON "StudentCourse"
FOR EACH ROW
WHEN (NEW.course_completed = TRUE)
EXECUTE FUNCTION award_student_points();

CREATE TRIGGER trg_award_points_update
AFTER UPDATE OF course_completed ON "StudentCourse"
FOR EACH ROW
WHEN (NEW.course_completed = TRUE AND OLD.course_completed = FALSE)
EXECUTE FUNCTION award_student_points();