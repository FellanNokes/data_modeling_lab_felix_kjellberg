# Databasutveckling för yrkeshögskolan YrkesCo

**Dokumenttyp:** Kravspecifikation  
**Projekt:** Databasutveckling för YrkesCo  
**Version:** 1.1  
**Status:** Under arbete  
**Senast uppdaterad:** 2026-01-13  
**Målgrupp:** Data Engineers, Utvecklare, Verksamhetsrepresentanter

## 1. Översikt

Detta dokument beskriver bakgrund, syfte, krav och leveranser för utveckling av en relationsdatabas åt yrkeshögskolan **YrkesCo**. Dokumentet är framtaget som underlag för datamodellering, implementation och presentation till både verksamhet och tekniska intressenter.

## 2. Bakgrund

YrkesCo är en yrkeshögskoleverksamhet som idag hanterar stora delar av sin information i separata Excel-filer samt i olika lärplattformar. Informationen omfattar bland annat:

- Studenter
- Utbildare och konsulter
- Utbildningsledare
- Kurser och program
- Klasser och utbildningsomgångar
- Organisationens olika anläggningar

Den nuvarande lösningen leder till:
- Dubbletter av data
- Bristande datakvalitet
- Svårigheter att dela information mellan roller
- Begränsad spårbarhet och kontroll av åtkomst till känsliga personuppgifter

YrkesCo har därför identifierat behovet av en centraliserad och normaliserad relationsdatabas.

## 3. Syfte och mål

Syftet med detta uppdrag är att:

- Designa en datamodell som speglar YrkesCos verksamhet och affärsregler
- Säkerställa god datakvalitet, normalisering och skalbarhet
- Möjliggöra kontrollerad åtkomst till känsliga personuppgifter
- Skapa en grund för framtida expansion (fler utbildningar och orter)

Målet är att leverera en databaslösning som uppfyller verksamhetens krav och är redo för implementation i PostgreSQL.

## 4. Omfattning

Arbetet omfattar:
- Kravanalys
- Konceptuell, logisk och fysisk datamodellering
- Implementation i PostgreSQL
- Testdata och verifierande SQL-frågor
- Presentation och videogenomgång av lösningen

## 5. Kravspecifikation

### 5.1 Personer (gemensam grundstruktur)
Databasen ska hantera flera typer av personer, exempelvis:
- Studenter
- Utbildare / kursledare
- Utbildningsledare
- Administrativ personal

Samtliga personer ska ha följande grundinformation:
- Förnamn
- Efternamn

Känsliga personuppgifter hanteras i ett separat table och innehåller:
- Personnummer
- E-postadress
- Adress
- Telefonnummer
- lön *för dem som är anställda av skolan*
---

### 5.2 Studenter
Utöver grundinformation enligt 5.1 ska databasen lagra följande för studenter:
- Poäng
- Är_aktiv
- Program_id (kan vara null om studenten endast går fristående kurser)

Alla studenter måste vara inskrivna i:
- Ett program **eller**
- En fristående kurs

Det finns inga studenter utan koppling till utbildning.  
En student kan läsa ett program och en eller flera fristående kurs parallellt.

Känsliga personuppgifter ska lagras i separata entiteter för att möjliggöra strikt åtkomstkontroll.

---

### 5.3 Utbildare (Kursledare)
- Varje kurs har **exakt en utbildare/kursledare**
- Utbildare kan vara:
  - Externa konsulter
  - Fast anställda utbildare (**BONUS**)
- För närvarande finns inga fastanställd kursledare, i framtiden ska dem kunna anställa kursledere. Nu är alla kursledare konsulter

---

### 5.4 Utbildningsledare
- En person är utbildningsledare endast om denne ansvarar för minst ett program
- Information om utbildningsledare och deras personuppgifter ska lagras (enligt 5.1)
- Varje utbildningsledare ansvarar för **exakt två program**
- Utbildningsledare är knutna till program, inte direkt till klasser

---

### 5.5 Kurser
Kurser ska innehålla följande information:
- Kursnamn
- Kurskod
- Antal poäng
- Kort kursbeskrivning

Övriga regler:
- En kurs kan endast ha en kursledare
- Kursnamn kan ändras
- Kurser kan kombineras
- Kursers poäng får inte ändras

---

### 5.6 Program
- Ett program består av ett antal kurser
- Antal kurser per program kan variera
- Program tas fram och beslutas av ledningsgrupp
- Ett program beviljas i omgångar

#### Omgång
- En omgång består av tre klasser
- En klass per år
- En hel utbildning sträcker sig över totalt fyra år

#### Fristående kurser
- Fristående kurser organiseras under ett särskilt program med namnet **"Fristående"**
- Fristående kurser ingår inte i ordinarie utbildningsprogram
- De kan vara inspirerade av programkurser, men är frikopplade från dem

---

### 5.7 Konsulter och företag
För konsulter ska databasen kunna lagra:
- Koppling till företag
- Företagsnamn
- Organisationsnummer
- F-skattsedel
- Företagsadress
- Arvode per timme

---

### 5.8 Organisation och anläggningar
- YrkesCo har idag två anläggningar:
  - Göteborg
  - Stockholm
- Datamodellen ska vara skalbar för framtida expansion till fler orter (**BONUS**)
- Samma program kan förekomma på flera orter, men betraktas som separata instanser

---

### 5.9 Säkerhet och dataskydd
- Känsliga personuppgifter inkluderar:
  - Personnummer
  - E-postadress
- Dessa ska lagras i separata tabeller
- Datamodellen ska möjliggöra roll- och behörighetsstyrd åtkomst

---

### 5.10 Tillägg och förtydliganden
- Ytterligare krav kan identifieras och läggas till under arbetets gång
- Alla tillägg eller förtydliganden ska tydligt dokumenteras och motiveras


## 6. Leveranser

### 6.1 Datamodellering
- Konceptuell datamodell
- Relationship statements för samtliga entiteter
- Logisk datamodell
- Fysisk datamodell
- Argumentation för att modellen uppfyller tredje normalformen (3NF)

### 6.2 Implementation
- PostgreSQL-implementation av den fysiska modellen
- SQL-skript för:
  - Skapande av tabeller
  - Inläsning av testdata
  - Verifierande queries (JOINs mellan relevanta tabeller)

Exempel på verifiering:
- Vilken utbildningsledare ansvarar för en specifik klass
- Vilka kurser ingår i ett program
- Vilka utbildare undervisar vilka kurser

### 6.3 Presentation
- Presentation av datamodellen och dess utvecklingssteg
- Fokus på både affärsperspektiv och teknisk implementation
- Levereras som PDF

### 6.4 Videopresentation
- Videopitch (10–15 minuter)
- Skärmdelning med genomgång av:
  - Datamodell
  - Designbeslut
  - Implementation
  - Kort demo av databasen

## 7. Kvalitetskriterier

### Godkänt
- Samtliga uppgifter genomförda korrekt
- Grundläggande datamodell som speglar verksamhetens krav
- Fungerande databasimplementation

### Väl godkänt
- Datamodell av hög kvalitet som tydligt speglar affärsregler
- Samtliga krav, inklusive BONUS, implementerade
- Korrekt och konsekvent användning av datamodelleringsterminologi
