SELECT STUDIO.ADDRESS
FROM STUDIO
WHERE STUDIO.NAME='DISNEY';

SELECT MOVIESTAR.BIRTHDATE
FROM MOVIESTAR
WHERE MOVIESTAR.NAME='Jack Nicholson';

SELECT STARSIN.STARNAME
FROM STARSIN
WHERE STARSIN.MOVIEYEAR=1980 OR STARSIN.MOVIETITLE='%Knight%';

SELECT MOVIEEXEC.NAME
FROM MOVIEEXEC
WHERE MOVIEEXEC.NETWORTH>10000;

SELECT MOVIESTAR.NAME
FROM MOVIESTAR
WHERE MOVIESTAR.GENDER='M' OR MOVIESTAR.ADDRESS='Prefect Rd.';

SELECT MOVIESTAR.NAME
FROM STARSIN, MOVIESTAR
WHERE MOVIESTAR.GENDER = 'M' AND STARSIN.MOVIETITLE = 'The Usual Suspects'
AND MOVIESTAR.NAME = STARSIN.STARNAME;

SELECT STARSIN.STARNAME 
FROM MOVIE, STARSIN
WHERE MOVIE.YEAR=1995 AND MOVIE.STUDIONAME='MGM' AND MOVIE.TITLE=STARSIN.MOVIETITLE;

SELECT DISTINCT MOVIEEXEC.NAME
FROM MOVIEEXEC, MOVIE
WHERE MOVIE.STUDIONAME='MGM' AND MOVIEEXEC.CERT#=MOVIE.PRODUCERC#;

SELECT MOVIE.TITLE
FROM MOVIE
WHERE MOVIE.LENGTH>(SELECT MOVIE.LENGTH FROM MOVIE WHERE MOVIE.TITLE='Star Wars');

SELECT MOVIEEXEC.NAME
FROM MOVIEEXEC
WHERE MOVIEEXEC.NETWORTH>(SELECT MOVIEEXEC.NETWORTH FROM MOVIEEXEC WHERE MOVIEEXEC.NAME='Stephen Spielberg');

SELECT MOVIE.TITLE
FROM MOVIE, MOVIEEXEC
WHERE MOVIEEXEC.NETWORTH>(SELECT MOVIEEXEC.NETWORTH FROM MOVIEEXEC WHERE MOVIEEXEC.NAME='Stephen Spielberg')
AND MOVIEEXEC.CERT#=MOVIE.PRODUCERC#;

(SELECT movieTitle AS title, movieYear AS year FROM STARSIN)
UNION
(SELECT title, year FROM MOVIE);

(SELECT name, address FROM MOVIESTAR WHERE gender = 'F')
INTERSECT
(SELECT name, address FROM MOVIEEXEC WHERE NETWORTH > 1000000);

(SELECT name, address FROM MOVIESTAR)
EXCEPT
(SELECT name, address FROM MOVIEEXEC);

SELECT MOVIESTAR.NAME 
FROM MOVIESTAR
WHERE MOVIESTAR.GENDER='F' AND
MOVIESTAR.NAME IN (SELECT MOVIEEXEC.NAME
				   FROM MOVIEEXEC 
				   WHERE MOVIEEXEC.networth > 10000000);

SELECT MOVIESTAR.NAME 
FROM MOVIESTAR 
WHERE MOVIESTAR.NAME NOT IN (SELECT MOVIEEXEC.NAME 
							 FROM MOVIEEXEC);

SELECT MOVIE.TITLE
FROM MOVIE
WHERE MOVIE.LENGTH > (SELECT MOVIE.LENGTH 
					  FROM MOVIE
				      WHERE MOVIE.TITLE='Star Wars');

SELECT MOVIE.TITLE, MOVIEEXEC.NAME 
FROM MOVIEEXEC, MOVIE
WHERE MOVIEEXEC.CERT#=MOVIE.PRODUCERC# AND MOVIEEXEC.NETWORTH > (SELECT MOVIEEXEC.NETWORTH 
 																 FROM MOVIEEXEC
															     WHERE MOVIEEXEC.NAME='Merv Griffin');

SELECT MOVIE.TITLE, MOVIEEXEC.NAME
FROM MOVIE
JOIN MOVIEEXEC ON MOVIEEXEC.CERT#=MOVIE.PRODUCERC#
			   AND MOVIEEXEC.NAME IN(SELECT MOVIEEXEC.NAME
			                         FROM MOVIEEXEC
									 JOIN MOVIE
									 ON MOVIE.TITLE='Star Wars'
									 AND MOVIE.PRODUCERC#=MOVIEEXEC.CERT#); 


SELECT DISTINCT MOVIEEXEC.NAME
FROM MOVIE
JOIN MOVIEEXEC
ON MOVIE.PRODUCERC#=MOVIEEXEC.CERT#
AND MOVIE.TITLE IN (SELECT STARSIN.MOVIETITLE
					FROM STARSIN
					JOIN MOVIESTAR
					ON MOVIESTAR.NAME='Harrison Ford'
					AND STARSIN.STARNAME=MOVIESTAR.NAME);

SELECT DISTINCT m.STUDIONAME, STARSIN.STARNAME
FROM MOVIE m
JOIN STARSIN
ON STARSIN.MOVIETITLE IN(SELECT MOVIE.TITLE
						 FROM MOVIE
						 WHERE MOVIE.STUDIONAME = m.STUDIONAME)
ORDER BY 1;

SELECT STARSIN.STARNAME, (SELECT MOVIEEXEC.NETWORTH FROM MOVIEEXEC WHERE MOVIEEXEC.NETWORTH >= ALL(SELECT MOVIEEXEC.NETWORTH FROM MOVIEEXEC)) AS NETWORTH, MOVIE.TITLE 
FROM MOVIE
JOIN STARSIN
ON STARSIN.MOVIETITLE=MOVIE.TITLE
AND MOVIE.PRODUCERC# IN (SELECT MOVIEEXEC.CERT# 
						 FROM MOVIEEXEC
					     WHERE MOVIEEXEC.NETWORTH >= ALL(SELECT MOVIEEXEC.NETWORTH
                       FROM MOVIEEXEC) );

SELECT DISTINCT MOVIESTAR.NAME, NULL AS MOVIETITLE
FROM MOVIESTAR
JOIN STARSIN
ON MOVIESTAR.NAME NOT IN (SELECT STARSIN.STARNAME   
						  FROM STARSIN
						  JOIN MOVIE
						  ON MOVIE.TITLE=STARSIN.MOVIETITLE);
 

 SELECT MOVIE.TITLE, MOVIE.YEAR, MOVIE.LENGTH
FROM MOVIE
WHERE (MOVIE.LENGTH>120 OR MOVIE.LENGTH IS NULL)
AND MOVIE.YEAR<2000;

SELECT MOVIESTAR.NAME, MOVIESTAR.GENDER 
FROM MOVIESTAR
WHERE UPPER(MOVIESTAR.NAME) LIKE UPPER('J%')
AND MOVIESTAR.BIRTHDATE > '1948-12-12';

SELECT MOVIE.STUDIONAME, COUNT(DISTINCT STARSIN.STARNAME)
FROM MOVIE
JOIN STARSIN
ON MOVIE.TITLE=STARSIN.MOVIETITLE
AND MOVIE.YEAR=STARSIN.MOVIEYEAR
GROUP BY MOVIE.STUDIONAME;

SELECT STARSIN.STARNAME, COUNT(STARSIN.STARNAME)
FROM STARSIN
GROUP BY STARSIN.STARNAME;

SELECT m.STUDIONAME, m.TITLE, m.YEAR
FROM MOVIE m
WHERE m.YEAR =		(SELECT MAX(YEAR)
					  FROM MOVIE 
					  WHERE MOVIE.STUDIONAME = m.STUDIONAME);

SELECT MOVIESTAR.NAME
FROM MOVIESTAR
WHERE MOVIESTAR.BIRTHDATE = (SELECT MAX(MOVIESTAR.BIRTHDATE)
						   FROM MOVIESTAR
						   WHERE MOVIESTAR.GENDER='m');

SELECT M.STUDIONAME, STARSIN.STARNAME, COUNT(STARSIN.MOVIETITLE)
FROM MOVIE M
JOIN STARSIN
ON M.TITLE = STARSIN.MOVIETITLE
AND M.YEAR = STARSIN.MOVIEYEAR
GROUP BY M.STUDIONAME, STARSIN.STARNAME
HAVING COUNT(STARSIN.MOVIETITLE) >= ALL (SELECT COUNT(STARSIN.MOVIETITLE)
                                        FROM STARSIN
										JOIN MOVIE
										ON MOVIE.TITLE=STARSIN.MOVIETITLE
										AND MOVIE.YEAR=STARSIN.MOVIEYEAR
										GROUP BY MOVIE.STUDIONAME, STARSIN.STARNAME);

SELECT MOVIE.TITLE, MOVIE.YEAR, COUNT(STARSIN.STARNAME)
FROM MOVIE    
JOIN STARSIN
ON MOVIE.TITLE=STARSIN.MOVIETITLE
AND MOVIE.YEAR=STARSIN.MOVIEYEAR
GROUP BY MOVIE.TITLE, MOVIE.YEAR
HAVING COUNT(STARSIN.STARNAME) > 2;
