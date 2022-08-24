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



 


