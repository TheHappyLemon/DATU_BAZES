-- LD4: Vingrinâjums Nr. 2 un 3

-- IZVEIDES FAILS
-- (Ðî faila kodçjums ir UTF-8)


-- Ja tabulu FILMAS nepiecieðams izdzçst, atkomentçjiet un izpildiet nâkamo rindu.
-- DROP TABLE FILMAS CASCADE CONSTRAINTS;


-- TABULAS IZVEIDE

CREATE TABLE FILMAS ( 
    RINDA INTEGER PRIMARY KEY,                          -- rindas numurs, unikâls identifikators
    NOSAUKUMS VARCHAR2(128 CHAR) NOT NULL,              -- filmas nosaukums (unikâls)
    VALSTS VARCHAR2(26 CHAR) NOT NULL,                  -- filmas uzòemðanas valsts (vairâkâm filmâm var bût viena un tâ pati)
    ZANRS VARCHAR2(26 CHAR) NOT NULL,                   -- filmas þanrs (vairâkâm filmâm var bût viens un tas pats)
    PIRMIZRADE DATE NOT NULL,                           -- filmas pirmizrâdes datums (var bût vienâds vairâkâm filmâm)
    ILGUMS NUMBER(4) NOT NULL,                          -- filmas ilgums veselâs minûtçs (var bût vienâds vairâkâm filmâm)
    REZISORS VARCHAR2(50 CHAR) NOT NULL,                -- filmas reþisors (vairâkâm filmâm var bût viens un tas pats)
    BUDZETS NUMBER(15) NOT NULL,                        -- filmas budþets veselos USD (var bût vienâds vairâkâm filmâm)
    IENEMUMI NUMBER(15) NOT NULL,                       -- filmas ieòçmumi veselos USD (var bût vienâdi vairâkâm filmâm)
    REITINGS NUMBER(3, 1) NOT NULL,                     -- filmas reitings skalâ no 0.0 lîdz 10.0 (arî nav unikâls)
    CONSTRAINT NOSAUKUMS_UNIQUE UNIQUE (NOSAUKUMS)      -- nosacîjums, ka nosaukumam jâbût unikâlam
);

-- 1. VAICÂJUMS
-- Atrast visas filmas, kas pieder ðausmu þanram (ZANRS: Ðausmas) un
-- kuru nosaukums sâkas ar C vai beidzas ar y.
-- Piemçram, ðie visi 4 nosaukumi derçtu: Cjak, Cmlkne, Enncey, Cnjjnxy
-- Izvadît filmas nosaukumu un þanru.
-- Kolonnu secîbu nemainît. Sakârtot pçc nosaukuma AUGOÐI.

SELECT NOSAUKUMS, ZANRS FROM FILMAS WHERE ((NOSAUKUMS LIKE 'C%') OR (NOSAUKUMS LIKE '%y')) AND ZANRS = 'Ðausmas' ORDER BY NOSAUKUMS DESC; 

-- 2. VAICÂJUMS
-- Atrast visas filmas, kuru reitings nav mazâks par 6.9 un nav lielâks par 8.5
-- un kuru nosaukuma 3. simbols nav "i".
-- Izvadît filmas nosaukumu un reitingu.
-- Kolonnu secîbu nemainît. Sakârtot pçc reitinga DILSTOÐI.

SELECT NOSAUKUMS, REITINGS FROM FILMAS WHERE REITINGS >= 6.9 AND REITINGS <= 8.5 AND NOSAUKUMS NOT LIKE '__i%' ORDER BY REITINGS DESC;
SELECT NOSAUKUMS, REITINGS FROM FILMAS WHERE REITINGS BETWEEN 6.9 AND 8.5 AND NOSAUKUMS NOT LIKE '__i%' ORDER BY REITINGS DESC;

-- 3. VAICÂJUMS
-- Aprçíinât, cik izmaksâja viena filmas uzòemðanas minûte katrai Drâmas
-- þanra filmai. Tas aprçíinâms budþetu dalot ar filmas ilgumu, kas ir dots minûtçs.
-- Izvadît filmas nosaukumu un minûtes izmaksas.
-- Minûtes izmaksas attçlot laukâ "Minûtes izmaksas".
-- Minûtes izmaksas noapaïot lîdz 2 cipariem aiz komata.
-- Kolonnu secîbu nemainît. Sakârtot pçc minûtes izmaksâm DILSTOÐI.

SELECT NOSAUKUMS, (ROUND((BUDZETS / ILGUMS), 2)) AS Minutes_izmaksas FROM FILMAS WHERE ZANRS = 'Drâma' ORDER BY Minutes_izmaksas DESC;

-- 4. VAICÂJUMS
-- Aprçíinât kopçjos iegûtos ieòçmumus par katra reþisora filmâm, kas pieder
-- vai nu Romantikas, vai nu Ðausmu, vai nu Fantastikas þanram.
-- Izvadît reþisoru un kopçjos ieòçmumus.
-- Kopçjos ieòçmumus izvadît laukâ "IENEMUMI_KOPA".
-- Kolonnu secîbu nemainît. Sakârtot pçc kopçjiem ieòçmumiem DILSTOÐI.

SELECT REZISORS, (SUM(IENEMUMI)) AS IENEMUMI_KOPA FROM FILMAS WHERE ZANRS IN ('Ðausmas', 'Romantika', 'Fantastika') GROUP BY REZISORS ORDER BY IENEMUMI_KOPA DESC;

-- 5. VAICÂJUMS
-- Aprçíinât, cik katra þanra filmu ir sarakstâ.
-- Izvadît TIKAI þanru nosaukumus (kolonna: ZANRS).
-- Izvadît tikai tos þanrus, kuros filmu skaits ir lielâks par 6.
-- Sarakstu sakârtot pçc þanram piederoðo filmu skaita dilstoði.

-- SELECT DISTINCT ZANRS, (COUNT(ZANRS)) AS FILMU_SKAITS FROM FILMAS WHERE FILMU_SKAITS > 6 GROUP BY ZANRS ORDER BY FILMU_SKAITS;

SELECT DISTINCT ZANRS 
FROM FILMAS
GROUP BY ZANRS HAVING COUNT(*) > 6
ORDER BY COUNT(*)
;

-- DATU IEVADE TABULÂ

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (1, 'Creator Of The Forsaken', 'Latvija', 'Drâma', to_date('12/29/2020', 'MM/DD/RRRR'), 98, 'Terry Gilliam', 9068372, 9257790, 4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (2, 'Cat Without Sin', 'ASV', 'Ðausmas', to_date('01/20/2016', 'MM/DD/RRRR'), 96, 'Terry Gilliam', 3027345, 4693155, 5.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (3, 'Criminals Of Utopia', 'Zviedrija', 'Ðausmas', to_date('02/01/2022', 'MM/DD/RRRR'), 105, 'George Lucas', 1853016, 6507460, 8.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (4, 'Enemies Of Yesterday', 'Kanâda', 'Ðausmas', to_date('12/10/2016', 'MM/DD/RRRR'), 116, 'Alexander Payne', 2530636, 7000540, 5.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (5, 'Swindlers And Aliens', 'Lielbritânija', 'Ðausmas', to_date('05/09/2019', 'MM/DD/RRRR'), 82, 'Michelangelo Antonioni', 8627317, 8766009, 3.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (6, 'Spiders And Dogs', 'Vâcija', 'Drâma', to_date('03/22/2018', 'MM/DD/RRRR'), 120, 'Kevin Smith', 4690036, 6118829, 9.5);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (7, 'History With Money', 'Latvija', 'Romantika', to_date('05/28/2017', 'MM/DD/RRRR'), 99, 'George Lucas', 3829924, 4881496, 6.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (8, 'World Of Gold', 'Lielbritânija', 'Drâma', to_date('07/26/2020', 'MM/DD/RRRR'), 92, 'Kevin Smith', 3617487, 9213857, 9.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (9, 'Blinded By My Family', 'Zviedrija', 'Ðausmas', to_date('01/18/2019', 'MM/DD/RRRR'), 90, 'Alexander Payne', 3783744, 8021529, 3.5);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (10, 'Dwelling In The End', 'ASV', 'Drâma', to_date('03/17/2017', 'MM/DD/RRRR'), 84, 'Judd Apatow', 4126284, 5380770, 6.5);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (11, 'Sounds In My Leader', 'Vâcija', 'Drâma', to_date('06/01/2020', 'MM/DD/RRRR'), 108, 'Kevin Smith', 2969586, 1794413, 5.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (12, 'Meeting At My Dreams', 'Zviedrija', 'Ðausmas', to_date('05/16/2020', 'MM/DD/RRRR'), 84, 'Michelangelo Antonioni', 8489403, 5802833, 3.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (13, 'Growing In Technology', 'Kanâda', 'Fantastika', to_date('07/17/2019', 'MM/DD/RRRR'), 102, 'Michelangelo Antonioni', 6715594, 2153782, 7.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (14, 'Battling In The Fires', 'ASV', 'Fantastika', to_date('02/17/2019', 'MM/DD/RRRR'), 84, 'Alexander Payne', 5762243, 4997058, 2.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (15, 'Learning From The Swamp', 'ASV', 'Romantika', to_date('11/23/2017', 'MM/DD/RRRR'), 119, 'Alexander Payne', 6633322, 5564140, 3.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (16, 'Battling At The Castle', 'Lielbritânija', 'Fantastika', to_date('07/03/2022', 'MM/DD/RRRR'), 90, 'Judd Apatow', 6524647, 7222540, 6.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (17, 'Weep For My Wife', 'Vâcija', 'Romantika', to_date('02/15/2019', 'MM/DD/RRRR'), 119, 'Terry Gilliam', 7874273, 8763846, 7.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (18, 'Still Breathing In The Fog', 'ASV', 'Romantika', to_date('12/11/2018', 'MM/DD/RRRR'), 75, 'Kevin Smith', 3041492, 1140407, 7.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (19, 'Clinging To The Commander', 'Lielbritânija', 'Romantika', to_date('01/11/2019', 'MM/DD/RRRR'), 94, 'Kevin Smith', 1420162, 8044137, 6.8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (20, 'Belonging To The Fog', 'ASV', 'Drâma', to_date('05/26/2017', 'MM/DD/RRRR'), 89, 'Pete Docter', 5145972, 1025802, 4.2);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (21, 'Run For The Country', 'ASV', 'Fantastika', to_date('04/11/2021', 'MM/DD/RRRR'), 118, 'George Lucas', 863773, 7664367, 8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (22, 'Controlling My Past', 'Kanâda', 'Romantika', to_date('05/23/2018', 'MM/DD/RRRR'), 119, 'George Lucas', 3619861, 1126446, 2.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (23, 'Eliminating The River', 'Lielbritânija', 'Romantika', to_date('04/09/2015', 'MM/DD/RRRR'), 98, 'Judd Apatow', 6387160, 3569376, 2.3);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (24, 'Becoming The Future', 'Latvija', 'Romantika', to_date('04/08/2018', 'MM/DD/RRRR'), 105, 'Michelangelo Antonioni', 5479533, 3015198, 6.9);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (25, 'Rejecting Eternity', 'Kanâda', 'Ðausmas', to_date('01/15/2019', 'MM/DD/RRRR'), 104, 'Terry Gilliam', 7582133, 7505072, 5.8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (26, 'Flying Into My Husband', 'Latvija', 'Fantastika', to_date('09/16/2022', 'MM/DD/RRRR'), 85, 'Kevin Smith', 2401355, 739333, 9.8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (27, 'Fade Into The Abyss', 'Vâcija', 'Ðausmas', to_date('12/22/2015', 'MM/DD/RRRR'), 118, 'George Lucas', 3643883, 8562374, 6.3);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (28, 'Destroying The Maze', 'Kanâda', 'Fantastika', to_date('10/27/2022', 'MM/DD/RRRR'), 90, 'Pete Docter', 1413857, 4376915, 4.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (29, 'Battle Of Technology', 'Kanâda', 'Romantika', to_date('03/09/2017', 'MM/DD/RRRR'), 84, 'Pete Docter', 530885, 6373674, 9.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (30, 'Flying Into The King', 'Lielbritânija', 'Romantika', to_date('05/02/2019', 'MM/DD/RRRR'), 75, 'Michelangelo Antonioni', 4530960, 5092516, 9.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (31, 'Fly', 'Lielbritânija', 'Ðausmas', to_date('08/01/2019', 'MM/DD/RRRR'), 45, 'Michelangelo Antonioni', 4530960, 5092516, 9.6);

COMMIT;