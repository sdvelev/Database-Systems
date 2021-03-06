SELECT CLASSES.CLASS, CLASSES.COUNTRY  
FROM CLASSES
WHERE CLASSES.NUMGUNS < 10;

SELECT SHIPS.NAME AS shipName  
FROM SHIPS
WHERE SHIPS.LAUNCHED < 1918;

SELECT OUTCOMES.SHIP, OUTCOMES.BATTLE
FROM OUTCOMES  
WHERE OUTCOMES.RESULT = 'sunk';

SELECT SHIPS.NAME 
FROM SHIPS
WHERE SHIPS.NAME = SHIPS.CLASS;

SELECT SHIPS.NAME 
FROM SHIPS
WHERE SHIPS.NAME LIKE 'R%';

SELECT SHIPS.NAME
FROM SHIPS
WHERE SHIPS.NAME LIKE '% %';

SELECT SHIPS.name
FROM CLASSES, SHIPS
WHERE CLASSES.CLASS=SHIPS.CLASS AND CLASSES.DISPLACEMENT>50000;

SELECT SHIPS.NAME, CLASSES.DISPLACEMENT, CLASSES.NUMGUNS
FROM CLASSES, SHIPS, OUTCOMES
WHERE CLASSES.CLASS = SHIPS.CLASS AND SHIPS.NAME = OUTCOMES.SHIP AND OUTCOMES.BATTLE='Guadalcanal';


(SELECT CLASSES.COUNTRY
FROM CLASSES
WHERE CLASSES.TYPE='bb')
INTERSECT
(SELECT CLASSES.COUNTRY
FROM CLASSES
WHERE CLASSES.TYPE='bC');

SELECT OUTCOMES.SHIP
FROM OUTCOMES
GROUP BY OUTCOMES.SHIP
HAVING COUNT(OUTCOMES.SHIP) > 1;

SELECT out1.SHIP 
FROM OUTCOMES AS out1, OUTCOMES AS out2, BATTLES AS bat1, BATTLES AS bat2 
WHERE out1.SHIP = out2.SHIP 
AND out1.RESULT='damaged' 
AND bat1.NAME = out1.BATTLE 
AND bat2.NAME = out2.BATTLE 
AND bat1.DATE < bat2.DATE;

SELECT DISTINCT CLASSES.COUNTRY
FROM CLASSES
WHERE CLASSES.NUMGUNS>= ALL(SELECT CLASSES.NUMGUNS
							FROM CLASSES);

SELECT DISTINCT SHIPS.CLASS
FROM SHIPS
WHERE SHIPS.NAME IN (SELECT OUTCOMES.SHIP
					 FROM OUTCOMES
					 WHERE OUTCOMES.RESULT='sunk');

SELECT SHIPS.NAME, SHIPS.CLASS
FROM SHIPS, CLASSES
WHERE SHIPS.CLASS=CLASSES.CLASS AND CLASSES.BORE=16;

SELECT OUTCOMES.BATTLE
FROM OUTCOMES
WHERE OUTCOMES.SHIP IN(SELECT SHIPS.NAME
					   FROM SHIPS
					   WHERE SHIPS.CLASS='Kongo');

SELECT c.CLASS, SHIPS.NAME
FROM SHIPS, CLASSES c 
WHERE c.CLASS=SHIPS.CLASS AND
c.NUMGUNS >= ALL(SELECT CLASSES.NUMGUNS
					   FROM CLASSES
					   WHERE CLASSES.BORE=c.BORE);

SELECT *
FROM SHIPS
RIGHT JOIN CLASSES
ON SHIPS.CLASS=CLASSES.CLASS
ORDER BY 1;

SELECT DISTINCT CLASSES.COUNTRY, SHIPS.NAME 
FROM CLASSES
JOIN SHIPS
ON CLASSES.CLASS=SHIPS.CLASS
AND SHIPS.NAME NOT IN (SELECT OUTCOMES.SHIP 
					   FROM OUTCOMES)
ORDER BY 1,2;

SELECT SHIPS.NAME AS 'Ship Name'
FROM CLASSES
JOIN SHIPS
ON CLASSES.CLASS=SHIPS.CLASS
AND CLASSES.NUMGUNS>=7
AND SHIPS.LAUNCHED=1916;

SELECT OUTCOMES.SHIP, BATTLES.NAME, BATTLES.DATE
FROM OUTCOMES
JOIN BATTLES
ON OUTCOMES.BATTLE=BATTLES.NAME
AND OUTCOMES.RESULT='sunk'
ORDER BY 2;

SELECT SHIPS.NAME, CLASSES.DISPLACEMENT, SHIPS.LAUNCHED
FROM CLASSES
JOIN SHIPS
ON CLASSES.CLASS=SHIPS.CLASS
AND SHIPS.NAME=SHIPS.CLASS;

SELECT CLASSES.CLASS, CLASSES.TYPE, CLASSES.COUNTRY, CLASSES.NUMGUNS, CLASSES.BORE, CLASSES.DISPLACEMENT
FROM SHIPS
RIGHT JOIN CLASSES
ON CLASSES.CLASS=SHIPS.CLASS
WHERE SHIPS.LAUNCHED IS NULL;

SELECT SHIPS.NAME, CLASSES.DISPLACEMENT, CLASSES.NUMGUNS, OUTCOMES.RESULT
FROM CLASSES
JOIN SHIPS
ON CLASSES.CLASS=SHIPS.CLASS
JOIN OUTCOMES
ON SHIPS.NAME=OUTCOMES.SHIP
AND OUTCOMES.BATTLE='North Atlantic';

SELECT COUNT(CLASSES.CLASS)
FROM CLASSES
WHERE CLASSES.TYPE='bb';

SELECT CLASSES.CLASS, AVG(CLASSES.NUMGUNS)
FROM CLASSES
WHERE CLASSES.TYPE='bb'
GROUP BY CLASSES.CLASS;

SELECT AVG(CLASSES.NUMGUNS)
FROM CLASSES
WHERE CLASSES.TYPE='bb';

SELECT SHIPS.CLASS, MIN(SHIPS.LAUNCHED), MAX(SHIPS.LAUNCHED)  
FROM SHIPS 
GROUP BY SHIPS.CLASS;

SELECT SHIPS.CLASS, COUNT(SHIPS.NAME)
FROM SHIPS
JOIN OUTCOMES
ON SHIPS.NAME=OUTCOMES.SHIP
AND OUTCOMES.RESULT='sunk'
GROUP BY SHIPS.CLASS;

SELECT SHIPS.CLASS, COUNT(SHIPS.NAME)
FROM SHIPS
JOIN OUTCOMES
ON SHIPS.NAME=OUTCOMES.SHIP
AND OUTCOMES.RESULT='sunk'
AND SHIPS.CLASS IN(SELECT SHIPS.CLASS
				   FROM SHIPS
				   GROUP BY SHIPS.CLASS
				   HAVING COUNT(SHIPS.CLASS) > 2)
GROUP BY SHIPS.CLASS

SELECT CLASSES.COUNTRY, ROUND(AVG(CLASSES.BORE),2)
FROM CLASSES 
JOIN SHIPS
ON CLASSES.CLASS=SHIPS.CLASS
GROUP BY CLASSES.COUNTRY;

SELECT DISTINCT SHIPS.NAME
FROM SHIPS
JOIN OUTCOMES
ON SHIPS.NAME=OUTCOMES.SHIP
WHERE SHIPS.NAME LIKE 'C%'
OR SHIPS.NAME LIKE 'K%';

SELECT SHIPS.NAME, CLASSES.COUNTRY
FROM SHIPS
JOIN CLASSES
ON SHIPS.CLASS=CLASSES.CLASS
WHERE SHIPS.NAME NOT IN (SELECT OUTCOMES.SHIP
                         FROM OUTCOMES)
OR SHIPS.NAME NOT IN (SELECT OUTCOMES.SHIP
                      FROM OUTCOMES
					  WHERE OUTCOMES.RESULT='sunk');

SELECT CLASSES.COUNTRY, COUNT(OUTCOMES.SHIP) 
FROM CLASSES
LEFT JOIN SHIPS
ON CLASSES.CLASS=SHIPS.CLASS
LEFT JOIN OUTCOMES
ON OUTCOMES.SHIP=SHIPS.NAME
AND OUTCOMES.RESULT='sunk'
GROUP BY CLASSES.COUNTRY;

SELECT OUTCOMES.BATTLE
FROM OUTCOMES  
GROUP BY OUTCOMES.BATTLE
HAVING COUNT(OUTCOMES.SHIP) > (SELECT COUNT(OUTCOMES.SHIP)
                              FROM OUTCOMES
							   WHERE OUTCOMES.BATTLE='Guadalcanal'); 

SELECT OUTCOMES.BATTLE
FROM OUTCOMES  
GROUP BY OUTCOMES.BATTLE
HAVING COUNT(OUTCOMES.SHIP) > (SELECT COUNT(OUTCOMES.SHIP)
                              FROM OUTCOMES
							   WHERE OUTCOMES.BATTLE='Surigao Strait');

SELECT SHIPS.NAME, C.DISPLACEMENT, C.NUMGUNS
FROM SHIPS
JOIN CLASSES C
ON C.CLASS=SHIPS.CLASS
WHERE C.DISPLACEMENT = (SELECT MIN(CLASSES.DISPLACEMENT)
							  FROM CLASSES)
AND C.NUMGUNS >= ALL (SELECT CLASSES.NUMGUNS
						FROM SHIPS
						JOIN CLASSES
						ON SHIPS.CLASS=CLASSES.CLASS
						WHERE CLASSES.DISPLACEMENT = C.DISPLACEMENT);

SELECT COUNT(O1.SHIP)
FROM OUTCOMES O1, OUTCOMES O2, BATTLES B1, BATTLES B2
WHERE O1.BATTLE=B1.NAME
AND O2.BATTLE=B2.NAME
AND O1.RESULT='damaged'
AND O2.RESULT='ok'
AND B1.DATE < B2.DATE
AND O1.SHIP=O2.SHIP;

SELECT O1.SHIP
FROM OUTCOMES O1, OUTCOMES O2, BATTLES B1, BATTLES B2
WHERE O1.BATTLE=B1.NAME
AND O2.BATTLE=B2.NAME
AND O1.RESULT='damaged'
AND O2.RESULT='ok'
AND B1.DATE < B2.DATE
AND O1.SHIP=O2.SHIP
AND (SELECT COUNT(O1.SHIP)
		 FROM OUTCOMES O1
		 WHERE O1.BATTLE = B1.NAME) < (SELECT COUNT(O2.SHIP)
													 FROM OUTCOMES O2
													WHERE O2.BATTLE = B2.NAME);
