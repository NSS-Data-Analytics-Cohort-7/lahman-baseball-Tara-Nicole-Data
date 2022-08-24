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

SELECT p.namefirst, p.namelast, a.g_all
FROM appearances AS a
LEFT JOIN people AS p
ON a.playerid = p.playerid
WHERE namefirst = 'Eddie' AND namelast = 'Gaedel'
ORDER BY p.height; 

--Question 2b Answer: 1 game

/*Question 2c: What is the name of the team for which he played?*/

SELECT DISTINCT(t.name), p.namefirst, p.namelast
FROM appearances AS a
LEFT JOIN people AS p
ON a.playerid = p.playerid
LEFT JOIN teams AS t
ON a.teamid = t.teamid
WHERE namefirst = 'Eddie' AND namelast = 'Gaedel';

--Question 2c Answer: St. Louis Browns

 


