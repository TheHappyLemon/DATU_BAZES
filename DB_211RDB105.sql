-- LD4: Vingrin�jums Nr. 2 un 3

-- IZVEIDES FAILS
-- (�� faila kod�jums ir UTF-8)


-- Ja tabulu FILMAS nepiecie�ams izdz�st, atkoment�jiet un izpildiet n�kamo rindu.
-- DROP TABLE FILMAS CASCADE CONSTRAINTS;


-- TABULAS IZVEIDE

CREATE TABLE FILMAS ( 
    RINDA INTEGER PRIMARY KEY,                          -- rindas numurs, unik�ls identifikators
    NOSAUKUMS VARCHAR2(128 CHAR) NOT NULL,              -- filmas nosaukums (unik�ls)
    VALSTS VARCHAR2(26 CHAR) NOT NULL,                  -- filmas uz�em�anas valsts (vair�k�m film�m var b�t viena un t� pati)
    ZANRS VARCHAR2(26 CHAR) NOT NULL,                   -- filmas �anrs (vair�k�m film�m var b�t viens un tas pats)
    PIRMIZRADE DATE NOT NULL,                           -- filmas pirmizr�des datums (var b�t vien�ds vair�k�m film�m)
    ILGUMS NUMBER(4) NOT NULL,                          -- filmas ilgums vesel�s min�t�s (var b�t vien�ds vair�k�m film�m)
    REZISORS VARCHAR2(50 CHAR) NOT NULL,                -- filmas re�isors (vair�k�m film�m var b�t viens un tas pats)
    BUDZETS NUMBER(15) NOT NULL,                        -- filmas bud�ets veselos USD (var b�t vien�ds vair�k�m film�m)
    IENEMUMI NUMBER(15) NOT NULL,                       -- filmas ie��mumi veselos USD (var b�t vien�di vair�k�m film�m)
    REITINGS NUMBER(3, 1) NOT NULL,                     -- filmas reitings skal� no 0.0 l�dz 10.0 (ar� nav unik�ls)
    CONSTRAINT NOSAUKUMS_UNIQUE UNIQUE (NOSAUKUMS)      -- nosac�jums, ka nosaukumam j�b�t unik�lam
);

-- 1. VAIC�JUMS
-- Atrast visas filmas, kas pieder �ausmu �anram (ZANRS: �ausmas) un
-- kuru nosaukums s�kas ar C vai beidzas ar y.
-- Piem�ram, �ie visi 4 nosaukumi der�tu: Cjak, Cmlkne, Enncey, Cnjjnxy
-- Izvad�t filmas nosaukumu un �anru.
-- Kolonnu sec�bu nemain�t. Sak�rtot p�c nosaukuma AUGO�I.

SELECT NOSAUKUMS, ZANRS FROM FILMAS WHERE ((NOSAUKUMS LIKE 'C%') OR (NOSAUKUMS LIKE '%y')) AND ZANRS = '�ausmas' ORDER BY NOSAUKUMS DESC; 

-- 2. VAIC�JUMS
-- Atrast visas filmas, kuru reitings nav maz�ks par 6.9 un nav liel�ks par 8.5
-- un kuru nosaukuma 3. simbols nav "i".
-- Izvad�t filmas nosaukumu un reitingu.
-- Kolonnu sec�bu nemain�t. Sak�rtot p�c reitinga DILSTO�I.

SELECT NOSAUKUMS, REITINGS FROM FILMAS WHERE REITINGS >= 6.9 AND REITINGS <= 8.5 AND NOSAUKUMS NOT LIKE '__i%' ORDER BY REITINGS DESC;
SELECT NOSAUKUMS, REITINGS FROM FILMAS WHERE REITINGS BETWEEN 6.9 AND 8.5 AND NOSAUKUMS NOT LIKE '__i%' ORDER BY REITINGS DESC;

-- 3. VAIC�JUMS
-- Apr��in�t, cik izmaks�ja viena filmas uz�em�anas min�te katrai Dr�mas
-- �anra filmai. Tas apr��in�ms bud�etu dalot ar filmas ilgumu, kas ir dots min�t�s.
-- Izvad�t filmas nosaukumu un min�tes izmaksas.
-- Min�tes izmaksas att�lot lauk� "Min�tes izmaksas".
-- Min�tes izmaksas noapa�ot l�dz 2 cipariem aiz komata.
-- Kolonnu sec�bu nemain�t. Sak�rtot p�c min�tes izmaks�m DILSTO�I.

SELECT NOSAUKUMS, (ROUND((BUDZETS / ILGUMS), 2)) AS Minutes_izmaksas FROM FILMAS WHERE ZANRS = 'Dr�ma' ORDER BY Minutes_izmaksas DESC;

-- 4. VAIC�JUMS
-- Apr��in�t kop�jos ieg�tos ie��mumus par katra re�isora film�m, kas pieder
-- vai nu Romantikas, vai nu �ausmu, vai nu Fantastikas �anram.
-- Izvad�t re�isoru un kop�jos ie��mumus.
-- Kop�jos ie��mumus izvad�t lauk� "IENEMUMI_KOPA".
-- Kolonnu sec�bu nemain�t. Sak�rtot p�c kop�jiem ie��mumiem DILSTO�I.

SELECT REZISORS, (SUM(IENEMUMI)) AS IENEMUMI_KOPA FROM FILMAS WHERE ZANRS IN ('�ausmas', 'Romantika', 'Fantastika') GROUP BY REZISORS ORDER BY IENEMUMI_KOPA DESC;

-- 5. VAIC�JUMS
-- Apr��in�t, cik katra �anra filmu ir sarakst�.
-- Izvad�t TIKAI �anru nosaukumus (kolonna: ZANRS).
-- Izvad�t tikai tos �anrus, kuros filmu skaits ir liel�ks par 6.
-- Sarakstu sak�rtot p�c �anram piedero�o filmu skaita dilsto�i.

-- SELECT DISTINCT ZANRS, (COUNT(ZANRS)) AS FILMU_SKAITS FROM FILMAS WHERE FILMU_SKAITS > 6 GROUP BY ZANRS ORDER BY FILMU_SKAITS;

SELECT DISTINCT ZANRS 
FROM FILMAS
GROUP BY ZANRS HAVING COUNT(*) > 6
ORDER BY COUNT(*)
;

-- DATU IEVADE TABUL�

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (1, 'Creator Of The Forsaken', 'Latvija', 'Dr�ma', to_date('12/29/2020', 'MM/DD/RRRR'), 98, 'Terry Gilliam', 9068372, 9257790, 4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (2, 'Cat Without Sin', 'ASV', '�ausmas', to_date('01/20/2016', 'MM/DD/RRRR'), 96, 'Terry Gilliam', 3027345, 4693155, 5.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (3, 'Criminals Of Utopia', 'Zviedrija', '�ausmas', to_date('02/01/2022', 'MM/DD/RRRR'), 105, 'George Lucas', 1853016, 6507460, 8.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (4, 'Enemies Of Yesterday', 'Kan�da', '�ausmas', to_date('12/10/2016', 'MM/DD/RRRR'), 116, 'Alexander Payne', 2530636, 7000540, 5.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (5, 'Swindlers And Aliens', 'Lielbrit�nija', '�ausmas', to_date('05/09/2019', 'MM/DD/RRRR'), 82, 'Michelangelo Antonioni', 8627317, 8766009, 3.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (6, 'Spiders And Dogs', 'V�cija', 'Dr�ma', to_date('03/22/2018', 'MM/DD/RRRR'), 120, 'Kevin Smith', 4690036, 6118829, 9.5);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (7, 'History With Money', 'Latvija', 'Romantika', to_date('05/28/2017', 'MM/DD/RRRR'), 99, 'George Lucas', 3829924, 4881496, 6.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (8, 'World Of Gold', 'Lielbrit�nija', 'Dr�ma', to_date('07/26/2020', 'MM/DD/RRRR'), 92, 'Kevin Smith', 3617487, 9213857, 9.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (9, 'Blinded By My Family', 'Zviedrija', '�ausmas', to_date('01/18/2019', 'MM/DD/RRRR'), 90, 'Alexander Payne', 3783744, 8021529, 3.5);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (10, 'Dwelling In The End', 'ASV', 'Dr�ma', to_date('03/17/2017', 'MM/DD/RRRR'), 84, 'Judd Apatow', 4126284, 5380770, 6.5);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (11, 'Sounds In My Leader', 'V�cija', 'Dr�ma', to_date('06/01/2020', 'MM/DD/RRRR'), 108, 'Kevin Smith', 2969586, 1794413, 5.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (12, 'Meeting At My Dreams', 'Zviedrija', '�ausmas', to_date('05/16/2020', 'MM/DD/RRRR'), 84, 'Michelangelo Antonioni', 8489403, 5802833, 3.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (13, 'Growing In Technology', 'Kan�da', 'Fantastika', to_date('07/17/2019', 'MM/DD/RRRR'), 102, 'Michelangelo Antonioni', 6715594, 2153782, 7.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (14, 'Battling In The Fires', 'ASV', 'Fantastika', to_date('02/17/2019', 'MM/DD/RRRR'), 84, 'Alexander Payne', 5762243, 4997058, 2.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (15, 'Learning From The Swamp', 'ASV', 'Romantika', to_date('11/23/2017', 'MM/DD/RRRR'), 119, 'Alexander Payne', 6633322, 5564140, 3.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (16, 'Battling At The Castle', 'Lielbrit�nija', 'Fantastika', to_date('07/03/2022', 'MM/DD/RRRR'), 90, 'Judd Apatow', 6524647, 7222540, 6.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (17, 'Weep For My Wife', 'V�cija', 'Romantika', to_date('02/15/2019', 'MM/DD/RRRR'), 119, 'Terry Gilliam', 7874273, 8763846, 7.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (18, 'Still Breathing In The Fog', 'ASV', 'Romantika', to_date('12/11/2018', 'MM/DD/RRRR'), 75, 'Kevin Smith', 3041492, 1140407, 7.7);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (19, 'Clinging To The Commander', 'Lielbrit�nija', 'Romantika', to_date('01/11/2019', 'MM/DD/RRRR'), 94, 'Kevin Smith', 1420162, 8044137, 6.8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (20, 'Belonging To The Fog', 'ASV', 'Dr�ma', to_date('05/26/2017', 'MM/DD/RRRR'), 89, 'Pete Docter', 5145972, 1025802, 4.2);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (21, 'Run For The Country', 'ASV', 'Fantastika', to_date('04/11/2021', 'MM/DD/RRRR'), 118, 'George Lucas', 863773, 7664367, 8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (22, 'Controlling My Past', 'Kan�da', 'Romantika', to_date('05/23/2018', 'MM/DD/RRRR'), 119, 'George Lucas', 3619861, 1126446, 2.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (23, 'Eliminating The River', 'Lielbrit�nija', 'Romantika', to_date('04/09/2015', 'MM/DD/RRRR'), 98, 'Judd Apatow', 6387160, 3569376, 2.3);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (24, 'Becoming The Future', 'Latvija', 'Romantika', to_date('04/08/2018', 'MM/DD/RRRR'), 105, 'Michelangelo Antonioni', 5479533, 3015198, 6.9);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (25, 'Rejecting Eternity', 'Kan�da', '�ausmas', to_date('01/15/2019', 'MM/DD/RRRR'), 104, 'Terry Gilliam', 7582133, 7505072, 5.8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (26, 'Flying Into My Husband', 'Latvija', 'Fantastika', to_date('09/16/2022', 'MM/DD/RRRR'), 85, 'Kevin Smith', 2401355, 739333, 9.8);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (27, 'Fade Into The Abyss', 'V�cija', '�ausmas', to_date('12/22/2015', 'MM/DD/RRRR'), 118, 'George Lucas', 3643883, 8562374, 6.3);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (28, 'Destroying The Maze', 'Kan�da', 'Fantastika', to_date('10/27/2022', 'MM/DD/RRRR'), 90, 'Pete Docter', 1413857, 4376915, 4.4);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (29, 'Battle Of Technology', 'Kan�da', 'Romantika', to_date('03/09/2017', 'MM/DD/RRRR'), 84, 'Pete Docter', 530885, 6373674, 9.1);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (30, 'Flying Into The King', 'Lielbrit�nija', 'Romantika', to_date('05/02/2019', 'MM/DD/RRRR'), 75, 'Michelangelo Antonioni', 4530960, 5092516, 9.6);

INSERT INTO FILMAS (RINDA, NOSAUKUMS, VALSTS, ZANRS, PIRMIZRADE, ILGUMS, REZISORS, BUDZETS, IENEMUMI, REITINGS) 
VALUES (31, 'Fly', 'Lielbrit�nija', '�ausmas', to_date('08/01/2019', 'MM/DD/RRRR'), 45, 'Michelangelo Antonioni', 4530960, 5092516, 9.6);

COMMIT;