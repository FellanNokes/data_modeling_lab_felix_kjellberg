# Data modellering Lab

## Instruktioner för att testa databasen med Docker

### 1. Se till att du har Docker Desktop och psql-klienten installerade

Du behöver inte installera PostgreSQL-server lokalt — containern sköter det.  
Det räcker att psql finns installerat på din dator.

---

### 2. Skapa en `.env`-fil i projektets root-mapp

Innehållet ska se ut ungefär så här (du kan ändra lösenord/databasnamn):

![Env](./documentation/env_example.png)

---

### 3. Kör följande kommandon i terminalen i denna ordning

Startar PostgreSQL-containern i bakgrunden:

```bash
docker compose up -d

Öppnar en interaktiv terminal inuti containern:
```bash
docker exec -it yrkesco bash
```

Startar psql-klienten och ansluter till din databas:
```bash
psql -U postgres -d [Database name]
```

Skapar databasschemat, tabeller, constraints och triggers:
```bash
\i sql/ddl.sql 
```

Laddar korrekt fake data:
```bash
\i sql/dml.sql 
```

Laddar medvetet felaktig testdata (valfritt):
```bash
\i sql/dml_fail.sql
```

Kör queries för att testa databasen:
```bash
\i sql/queries.sql
```


## Konceptuella Modellen

Arbetet börjar med att analysera och bryta ned kravspecifikationen:  
[**Kravspecifikation för Yrkesco-databasen**](./documentation/kravspecifikation_databas_yrkesco_v1.1.md).

Utifrån denna identifierar jag de centrala verksamhetsbehoven och tar fram de viktigaste entiteterna, deras attribut samt hur de relaterar till varandra. Det första steget är att skapa en **konceptuell modell**, där fokus ligger helt på verksamhetslogik utan tekniska detaljer som primärnycklar, datatyper eller normalisering.

När version 2 av modellen är färdig börjar strukturen bli tillräckligt stabil för att gå vidare med nästa steg:  
[**Relationship Statements**](./documentation/data_modeller.md).

I detta skede dokumenteras varje relation mellan entiteter (1–1, 1–M eller M–M) och motiveras utifrån verksamhetskraven. Relationship statements fungerar som ett mellansteg mellan konceptuell och logisk modell och säkerställer att relationerna är korrekta innan jag går vidare till att bygga den **logiska modellen**, där tabeller, primärnycklar och bryggtabeller formaliseras.

---

### Utvecklingen av den konceptuella modellen  
*Nedan visas bilder som illustrerar hur den konceptuella modellen har utvecklats steg för steg under projektets gång (från vänster till höger).*

---



<p align="center">
  <img src="./documentation/conceptuel_model/conceptuel_model_v1.png" width="300">
  <img src="./documentation/conceptuel_model/conceptuel_model_v2.png" width="300">
  <img src="./documentation/conceptuel_model/conceptuel_model_v3.png" width="300">
  <img src="./documentation/conceptuel_model/conceptuel_model_v4.png" width="300">
</p>

## Logiska Modellen

Efter att den konceptuella modellen kändes stabil fortsatte jag med att ta fram den första versionen av den **logiska modellen**. I detta steg ligger fokus på struktur, relationer och datatyper utan att ännu ta hänsyn till fysisk implementation.

### Syfte med den logiska modellen
Målet är att skapa en modell som:
- eliminerar alla många-till-många-relationer (M-M) genom att införa **bridge tables**  
- säkerställer korrekt användning av **primärnycklar** och **främmande nycklar**
- förtydligar entiteters relationer och kardinaliteter  
- lägger grunden för en framtida fysisk modell utan att behöva göra större förändringar senare  
- möjliggör framtida funktioner som triggers, constraints och data integrity-regler

### Viktiga designbeslut
Under arbetet med den logiska modellen definierades bland annat:

- **Alla M-M-relationer ersattes av omkopplingstabeller**  
  Exempel:  
  `ProgramCourseFacility`, `StandaloneCourseFacility`, `StudentCourse`.

- **Datatyper valdes med avsikt**  
  - Personnummer och telefonnummer lagras som `varchar`  
  - Kurskod använder ett standardiserat format som kan härledas till klass + nummer  
  - Poäng härleds alltid från veckor genom constraint (`points = weeks * 5`)

- **Regler implementerades som constraints**  
  - Teachers kan antingen vara `"Anställd"` eller `"Konsult"`  
  - Konsulter måste tillhöra ett företag  
  - Endast färdigställda kurser får ett completion-date  
  - `awarded_points` måste vara ≥ 0

- **Härledda värden planeras redan här**  
  T.ex. studenternas totala poäng, vilket senare hanteras via triggers i den fysiska modellen.

### Viktigt att ta med från processen
- Den logiska modellen skapades iterativt. När strukturen tydliggjordes upptäcktes flera behov av nya tabeller (exempelvis för standalone-kurser och program-kopplingar).  
- Flera attribut flyttades om baserat på normalisering och 1NF/2NF/3NF-principer.  
- ChatGPT användes aktivt som bollplank för att resonera kring databasschema, constraints, relationer och optimeringar. Detta gav snabbare iterationer och hjälp att upptäcka förbättringar tidigt.

### Övergång mot fysisk modell
När den logiska modellen blev tillräckligt stabil kunde jag gå vidare till den fysiska modellen.  
På grund av arbetet i detta steg behövde nästan inga strukturella förändringar göras senare, vilket sparade mycket tid.

Den fysiska modellen fick då:
- faktiska `IDENTITY`-sekvenser på alla PK  
- detaljerade constraints, triggers och check-regler  
- ett dedikerat schema (`Yrkesco`)  
- korrekta foreign keys och unika regler  
- funktioner som hanterar härledda värden (som poäng vid slutförda kurser)

Det här visar hur viktigt det är att den logiska modellen är robust innan man går vidare.

Bilder på [alla logiska modeller](./documentation/logical_model)

Slutresultat:
![Konceptuell modell](./documentation/logical_model/logical_model_v10.png)

## Argument för att tredje normalformen (3NF) uppnås
Datamodellen uppfyller tredje normalformen (3NF) eftersom alla icke-nyckelattribut i varje tabell beror direkt på primärnyckeln och inga transitiva beroenden förekommer. Känslig data, adressinformation, kursresultat och organisatorisk information har separerats i egna entiteter för att säkerställa dataintegritet och minimera redundans.

## Fysiska Modellen

När den logiska modellen var stabil och alla affärsregler var tydligt definierade kunde jag gå vidare och skapa den fysiska datamodellen. Arbetet med den fysiska modellen har handlat om att mappa alla entiteter, relationer och regler från den logiska modellen till verkliga PostgreSQL-tabeller, med korrekta datatyper, constraints och tekniska implementationer.

### Fokusområden i arbetet

**1. Datatyper och normalisering**  
Samtliga tabeller har utformats för att följa 3NF. Detta innebär att:
- Alla tabeller har en primärnyckel.
- Alla attribut beror direkt på primärnyckeln.
- Det finns inga transistiva beroenden.  
Exempelvis lagras adressdata i en egen tabell och kopplas via `address_id`, och känsliga personuppgifter ligger i `PersonSensitiveData` i en ren 1-1-relation mot `Person`.

**2. Identity-kolumner för primärnycklar**  
De flesta primärnycklar genereras med `GENERATED ALWAYS AS IDENTITY`, vilket gör att PostgreSQL sköter ID-hanteringen automatiskt och minskar risken för krockar och manuella misstag.

**3. Constraints för affärsregler**  
En stor del av den pysiska modellen handlar om att implementera affärslogiken direkt i databasen. Några viktiga exempel:

- En konsult måste ha ett företag kopplat (och en anställd får inte ha det).  
- Kursers poäng måste vara exakt 5 per vecka (`CHECK (points = weeks * 5)`).
- `StudentCourse` kräver att avslutade kurser har ett completion-datum.  
- Unika kombinationer i tabeller som `ProgramCourseFacility` och `StudentCourse` förhindrar dubbletter.

Dessa constraints fungerar som en extra valideringsnivå och gör modellen betydligt mer robust.

**4. Trigger för poänghantering**  
En trigger används för att automatiskt ge poäng när en student slutför en kurs. Detta säkerställer:
- `awarded_points` sätts på `StudentCourse`
- Studentens totala `points` uppdateras
- Studenten markeras som aktiv
Allt utan risk att poäng ges två gånger.

**5. Hantering av standalone-kurser**  
Eftersom fristående kurser inte ska kopplas till något program skapades en separat tabell:  
`StandaloneCourseFacility`.  
Den dedikerade tabellen gör att programlogiken hålls ren, samtidigt som fristående kurser kan kopplas till olika anläggningar vid behov.

### Resultat

Den slutliga fysiska modellen är konsekvent, normaliserad och strikt. Den är konstruerad för:
- Hög datakvalitet  
- God prestanda  
- Enkel underhållbarhet  
- Säker hantering av känsliga personuppgifter  
- Tydlig separation mellan programkurser och fristående kurser  

Under arbetet använde jag ChatGPT som bollplank för att resonera kring designbeslut, validera relationer och säkerställa att modellen byggdes steg för steg utan att introducera nya normaliseringsproblem.  
Det hjälpte även till att identifiera edge-cases, förbättra constraints och formulera triggers korrekt.

Den fysiska modellen är nu redo att användas som bas för databasimplementationen och vidare utveckling.

## Sammanfattning av DML (Fake Data)

DML-datan är framtagen för att spegla en realistisk och komplett miljö för YrkesCo, baserad på alla affärsregler i kravspecifikationen. Den är genererad i samarbete med ChatGPT som stöd och bollplank genom hela processen.

Datan omfattar alla centrala delar av verksamheten: städer, adresser, personer, känsliga personuppgifter, studenter, utbildningsledare, klasser, program, kurser, lärare, konsulter och anläggningar.

### Struktur och innehåll
- **Studenter** inkluderar både namnspecifika krav (Felix, Anja och Rikard) och flera fiktiva “nördiga” namn.  
  DE25 har fem studenter, övriga klasser två.
- **Education Leaders** är Elvin och Melvin, där Elvin har högre lön enligt kravspecifikationen.
- **Konsulter och företag** omfattar bland annat AIgineer, där lärarna Kokchun och Debbie ingår.
- **Kurser** är anpassade efter respektive program, t.ex. Python, SQL och Data Modeling för DE, samt Unity och C# för GP.
- **Standalone-kurser** är inkluderade och separerade från programstrukturen.
- **ProgramCourseFacility** beskriver vilka kurser som ges på vilken anläggning.
- **StudentCourse** innehåller studenternas kursdeltagande och slutförande. Triggern uppdaterar studentpoäng automatiskt.

### Syfte
DML-datan är designad för att:
- Vara realistisk men fortfarande lätt att arbeta med.
- Testa constraints, triggers och relationslogik.
- Visa att datamodellen fungerar i praktiken.
- Ge en komplett testmiljö för queries, rapporter och vidare utveckling.

Datan utgör därmed en robust grund för både funktionell testning och demonstration av databasens design.

