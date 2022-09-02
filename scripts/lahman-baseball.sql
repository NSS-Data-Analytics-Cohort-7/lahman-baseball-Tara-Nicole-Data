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

SELECT ((yearid/10)*10) as decade,
    ROUND(CAST(SUM(so) AS NUMERIC) / CAST(SUM(g/2) AS NUMERIC),2) AS avg_strikeouts, 
    ROUND(CAST(SUM(hr) AS NUMERIC) / CAST(SUM(g/2) AS NUMERIC),2) AS avg_homeruns
FROM teams
WHERE ((yearid/10)*10) BETWEEN '1920' AND '2010'
GROUP BY decade
ORDER BY decade DESC;

--Question 5 Answer: Both average strikeouts and average home runs increase by decade. 

/*Question 6: Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.*/

SELECT (ROUND(sb/(sb+cs):: DECIMAL,2)) AS successful_attempts, 
       playerid
FROM batting
WHERE yearid = '2016' AND sb+cs >= 20
ORDER BY successful_attempts DESC;

--Question 6 Answer: 

/*Question 7a: From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?*/ 

SELECT yearid, teamid, w, wswin
FROM teams
WHERE yearid BETWEEN '1970' AND '2016' 
      AND wswin = 'N'
ORDER BY w DESC; 

--Question 7a Answer: 116 (Seattle Mariners)

/*Question 7b: What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year.*/ 

SELECT yearid, teamid, w, wswin
FROM teams
WHERE yearid BETWEEN '1970' AND '2016' 
      AND wswin = 'Y' 
      AND yearid <> '1981'
ORDER BY w;

--Question 7b Answer: 83 (St. Louis Cardinals)

/*Question 7c: How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?*/
--CTE teams with max wins and World Series win
--CTE any team that won World Series (max/all = percentage)

--Max wins of each year and World Series win
WITH mw AS 
    (SELECT name, 
            yearid, 
            MAX(MAX(w)) OVER (PARTITION BY yearid) AS max_wins
     FROM teams
     WHERE yearid BETWEEN '1970' AND '2016' 
           AND yearid <> '1981'
           AND wswin = 'Y'
     GROUP BY name, yearid
     ORDER BY max_wins DESC),
   
--Count of all teams that won World Series    
aw AS 
    (SELECT COUNT (name)
     FROM teams
     WHERE yearid BETWEEN '1970' AND '2016'
           AND yearid <> '1981' 
           AND wswin = 'Y'
    )

/*Question 8: Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.*/

SELECT park, team, attendance/games AS avg_attendance
FROM homegames
WHERE span_first BETWEEN '2016-01-01' AND '2016-12-31'
    AND span_last BETWEEN '2016-01-01' AND '2016-12-31'
    AND games > 10
ORDER BY avg_attendance DESC
LIMIT 5; 

SELECT park, team, attendance/games AS avg_attendance
FROM homegames
WHERE span_first BETWEEN '2016-01-01' AND '2016-12-31'
    AND span_last BETWEEN '2016-01-01' AND '2016-12-31'
    AND games > 10
ORDER BY avg_attendance 
LIMIT 5; 

--Question 8 Answer: Top 5 - LAN, SLN, TOR, SFN, CHN; Bottom 5 - TBA, OAK, CLE, MIA, CHA

/*Question 9: Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.*/

WITH nl AS (
    SELECT DISTINCT (a.playerid), 
           a.yearid,
           t.name AS team_name,
           CONCAT(p.namefirst, ' ', p.namelast) AS manager_name
    FROM awardsmanagers AS a
    INNER JOIN people AS p
    USING (playerid)
    INNER JOIN managers AS m
    ON a.yearid = m.yearid 
        AND a.playerid = m.playerid
    INNER JOIN teams AS t
    ON m.teamid = t.teamid 
        AND m.yearid = t.yearid
    WHERE a.awardid = 'TSN Manager of the Year'
        AND a.lgid = 'NL'
    ORDER BY yearid),

al AS (
    SELECT DISTINCT (a.playerid), 
           a.yearid,
           t.name AS team_name,
           CONCAT(p.namefirst, ' ', p.namelast) AS manager_name
    FROM awardsmanagers AS a
    INNER JOIN people AS p
    USING (playerid)
    INNER JOIN managers AS m
    ON a.yearid = m.yearid 
        AND a.playerid = m.playerid
    INNER JOIN teams AS t
    ON m.teamid = t.teamid 
        AND m.yearid = t.yearid
    WHERE a.awardid = 'TSN Manager of the Year'
        AND a.lgid = 'AL'
    ORDER BY yearid)
    
SELECT DISTINCT (nl.manager_name),
       nl.team_name,
       al.team_name
FROM nl 
INNER JOIN al
USING (playerid);

--Question 9 Answer: Davey Johnson - Washington Nationals, Baltimore Orioles; Jim Leyland - Pittsburgh Pirates, Detroit Tigers

/*Question 10: Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.*/

WITH ch AS (
SELECT playerid,
       MAX(hr) AS career_high
FROM batting
GROUP BY playerid
ORDER BY career_high DESC)

SELECT SUM(b.hr) AS total_homeruns,
       CONCAT(p.namefirst, ' ', p.namelast) AS full_name,
FROM batting AS b
LEFT JOIN people AS p
USING (playerid)
INNER JOIN ch
USING (playerid)
WHERE b.yearid = '2016' 
    AND debut < '2007-01-01' 
    AND b.hr >= 1
    AND b.hr = ch.career_high
GROUP BY full_name
ORDER BY total_homeruns DESC; 

/*Question 10 Answer: 
    Edwin Encarnacion - 42
    Robinson Cano - 39
    Mike Napoli - 34
    Angel Pagan - 12
    Rajai Davis - 12
    Adam Wainwright - 2
    Francisco Liriano - 1
    Bartolo Colon - 1*/
    
/*Question 11: Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.*/

SELECT s.teamid, 
       t.w,
       SUM(s.salary),
       s.yearid
FROM salaries AS s
INNER JOIN teams AS t
USING (teamid)
WHERE teamid = 'LAN'
GROUP BY s.yearid, s.teamid, t.w
ORDER BY s.yearid DESC

SELECT teamid, w
FROM teams