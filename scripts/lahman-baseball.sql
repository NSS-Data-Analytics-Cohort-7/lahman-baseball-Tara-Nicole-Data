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
    MIN (height)
FROM people
GROUP BY namefirst, namelast
LIMIT 1; 

--Question 2a Answer: Ned Harris, 71 inches or 5 feet 9 inches

/*Question 2b: How many games did he play in?*/




 


