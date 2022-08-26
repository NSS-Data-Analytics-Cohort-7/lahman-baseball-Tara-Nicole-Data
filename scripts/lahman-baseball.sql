/*Question 1: What range of years for baseball games played does the provided database cover?*/

SELECT 
    MIN(yearid), 
    MAX(yearid)
FROM teams;

--OR

SELECT 
    MIN(year),
    MAX(year)
FROM homegames;

--Question 1 Answer: 1871-2016

/*Question 2a: Find the name and height of the shortest player in the database.*/

SELECT 
    namefirst,
    namelast,
    height
FROM people
ORDER BY height;  

--Question 2a Answer: Eddie Gaedel, 43 inches or 3 foot 6 inches

/*Question 2b: How many games did he play in?*/

SELECT 
    p.namefirst, 
    p.namelast, 
    a.g_all
FROM appearances AS a
LEFT JOIN people AS p
ON a.playerid = p.playerid
WHERE namefirst = 'Eddie' AND namelast = 'Gaedel'
ORDER BY p.height; 

--Question 2b Answer: 1 game

/*Question 2c: What is the name of the team for which he played?*/

SELECT 
    DISTINCT(t.name), 
    p.namefirst, 
    p.namelast
FROM appearances AS a
LEFT JOIN people AS p
ON a.playerid = p.playerid
LEFT JOIN teams AS t
ON a.teamid = t.teamid
WHERE namefirst = 'Eddie' AND namelast = 'Gaedel';

--Question 2c Answer: St. Louis Browns

/*Question 3: Find all the players in the database who played at Vanderbilt University. Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?*/

SELECT 
    c.schoolid, 
    p.namefirst,
    p.namelast,
    CAST(CAST(SUM(DISTINCT s.salary) AS NUMERIC) AS MONEY) AS salary--s/o to Sarah
FROM collegeplaying AS c
JOIN people AS p
    USING (playerid)
JOIN salaries AS s
    USING (playerid)
WHERE schoolid = 'vandy' AND p.namelast = 'Price'
GROUP BY  
    p.namefirst, 
    p.namelast, 
    c.schoolid;


/*FROM TYLER: SELECT CONCAT(vandy.namefirst, ' ', vandy.namelast) AS name,
      CAST(CAST(SUM(s.salary) AS numeric) AS money) AS player_pay
    FROM (SELECT p.playerid,
            p.namefirst,
            p.namelast
          FROM people AS p
          LEFT JOIN collegeplaying AS cp
          USING (playerid)
          JOIN schools AS s
          USING (schoolid)
          WHERE s.schoolname LIKE '%Vanderbilt%'
          GROUP BY p.playerid) AS vandy
    JOIN salaries AS s
    ON vandy.playerid = s.playerid
    WHERE s.salary IS NOT null
    GROUP BY vandy.namefirst,
      vandy.namelast
    ORDER BY player_pay DESC;*/



--Question 3 Answer: David Price, $245,553,888

/*Question 4: Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS","1B","2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.*/

SELECT
    SUM(po) AS total_putouts,
    CASE WHEN pos = 'OF' THEN 'Outfield'
         WHEN pos = 'SS' THEN 'Infield'
         WHEN pos = '1B' THEN 'Infield'
         WHEN pos = '2B' THEN 'Infield'
         WHEN pos = '3B' THEN 'Infield'
         WHEN pos = 'P' THEN 'Battery'
         WHEN pos = 'C' THEN 'Battery'
         END AS grouped_positions
FROM fielding
WHERE yearid = '2016'
GROUP BY grouped_positions
ORDER BY total_putouts DESC; 

--Question 4 Answer: Infield-58,934; Battery-41,424; Outfield-29,560

/*Question 5: Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?*/

SELECT g, ROUND(AVG(so),2), (yearid/10)*10 AS decade
FROM teams
GROUP BY decade, g
HAVING ((yearid/10)*10) >= '1920'
ORDER BY decade DESC;

SELECT g, so, yearid, teamid
FROM teams
WHERE yearid <= '1920'
ORDER BY yearid DESC; 

--Gives number of games played per team per year
SELECT teamid, g, yearid
FROM teams
WHERE yearid >= '1920'
ORDER BY yearid, teamid;

SELECT COUNT(g), yearid
FROM teams
WHERE yearid >= '1920'
GROUP BY yearid
ORDER BY yearid DESC; 

SELECT MAX(yearid)
FROM teams;
--somehow sum together each year in each decade...case when statement to rename the decades? 

SELECT SUM(so)/COUNT(g), -- trying to figure out average of strikeouts per game
    CASE WHEN yearid BETWEEN '1920' AND '1929' THEN '1920'
         WHEN yearid BETWEEN '1930' AND '1939' THEN '1930'
         WHEN yearid BETWEEN '1940' AND '1949' THEN '1940'
         WHEN yearid BETWEEN '1950' AND '1959' THEN '1950'
         WHEN yearid BETWEEN '1960' AND '1969' THEN '1960'
         WHEN yearid BETWEEN '1970' AND '1979' THEN '1970'
         WHEN yearid BETWEEN '1980' AND '1989' THEN '1980'
         WHEN yearid BETWEEN '1990' AND '1999' THEN '1990'
         WHEN yearid BETWEEN '2000' AND '2009' THEN '2000'
         ELSE '2010' END AS decades
FROM teams
GROUP BY decades
ORDER BY decades DESC

SELECT ROUND(g/so),2
FROM teams
WHERE teamid = 'BOS' AND yearid = '1920'

SELECT AVG(so)
FROM teams
WHERE yearid = '1920';

