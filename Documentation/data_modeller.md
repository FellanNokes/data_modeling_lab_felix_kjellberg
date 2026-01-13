# Konceptuell Modell

## Entities och relationship statements
### Person
- En person kan ha en eller flera roller: student, utbildare och/eller utbildningsledare.
- Varje student, utbildare och utbildningsledare är exakt en person.

---

### Student
- En student är inskriven i ett eller flera program.  
  *Fristående kurser organiseras under programmet "Fristående".*
- En student kan vara en del av en klass.
- En student kan gå på en eller flera kurser.

---

### Utbildningsledare
- En utbildningsledare ansvarar för exakt två program.
- Varje program ansvaras av en utbildningsledare.

---

### Utbildare (kursledare)
- En utbildare kan undervisa i en eller flera kurser.
- En utbildare kan vara kopplad till ett företag.

---

### Klass
- En klass består av flera studenter.
- En klass genomför flera kurser.
- En klass tillhör exakt ett program och en omgång.

---

### Program
- Ett program består av flera klasser.
- Ett program består av flera kurser.

---

### Anläggning
- En anläggning erbjuder ett eller flera program.
- En anläggning erbjuder kurser via sina program.

---

### Kurs
- En kurs tillhör exakt ett program.
- En kurs kan ha flera studenter.
- En kurs har exakt en utbildare.

---
### Omgång
- En omgång kan ha en eller flera klasser.

## Sammanfattning – VG vs QA-förtydliganden

### VG / Bas (ursprungliga krav)
- Person och rollstruktur (student, utbildare, utbildningsledare)
- Relation mellan student och kurser
- Relation mellan utbildare och kurser
- Program består av flera kurser
- Program består av flera klasser
- Kurs har exakt en utbildare
- Kurs kan ha flera studenter
- Anläggning erbjuder ett eller flera program

### Extra / Förtydliganden från Q&A med Elvin
- En utbildningsledare ansvarar för exakt två program
- Varje program ansvaras av en utbildningsledare
- Begreppet klass och dess relationer:
  - Klass består av flera studenter
  - Klass genomför flera kurser
  - Klass tillhör exakt ett program och en omgång
- Omgång:
  - En omgång kan ha en eller flera klasser
- Studenter måste vara inskrivna i program eller fristående kurser
- Fristående kurser organiseras under ett särskilt program
- Utbildare kan vara kopplade till företag
- Kurser erbjuds via anläggningarnas program

