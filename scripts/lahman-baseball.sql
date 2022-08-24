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
    s.schoolname, 
    p.namefirst,
    p.namelast,
    CAST(CAST(SUM(salary) AS NUMERIC) AS MONEY) --s/o to Sarah
FROM schools AS s
LEFT JOIN collegeplaying AS c
    ON s.schoolid = c.schoolid
LEFT JOIN people AS p
    ON p.playerid = c.playerid
LEFT JOIN salaries AS s2
    ON p.playerid = s2.playerid
WHERE schoolname = 'Vanderbilt University' 
GROUP BY 
    s.schoolname, 
    p.namefirst, 
    p.namelast
ORDER BY SUM(salary) DESC;

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


