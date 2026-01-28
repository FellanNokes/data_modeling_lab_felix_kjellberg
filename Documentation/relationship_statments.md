## Entities och relationship statements
### Person
- En person kan ha en eller flera roller: student, utbildare och/eller utbildningsledare.
- Varje student, utbildare och utbildningsledare är exakt en person.

---

### Student
- En student är inskriven i ett eller inget program.  
  *Fristående kurser organiseras under standalone i kurser.*
- En student kan vara en del av en klass.
- En student kan gå på en eller flera kurser.

---

### Utbildningsledare
- En utbildningsledare ansvarar för exakt två program.
- Varje program ansvaras av en utbildningsledare.
- En utbildningsledare kan vara konsult

---

### Konsult
- En konsult tillhör ett företag

---

### Företag
- Ett företag har en eller flera konsulter

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
- En anläggning erbjuder en eller flera kurser.

---

### Kurs
- En kurs kan tillhör ett program eller vara fristående.
- En kurs kan ha flera studenter.
- En kurs har exakt en utbildare.

---
### Omgång
- En omgång kan ha en eller flera klasser.
- En omgång kan ha ett eller flera program.

