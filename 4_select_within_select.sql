-- # 1. List each country name where the population is larger than
-- # 'Russia'.
SELECT name
FROM world
WHERE population > (
  SELECT population
  FROM world
  WHERE name = 'Russia');

-- # 2. List the name and continent of countries in the continents
-- # containing 'Belize', 'Belgium'.
SELECT name, continent
FROM world
WHERE continent IN (
  SELECT continent 
  FROM world
  WHERE name IN ('Belize', 'Belgium'));

-- # 3. Show the countries in Europe with a per capita GDP greater than
-- # 'United Kingdom'.
SELECT name
FROM world
WHERE continent = 'Europe'
AND gdp/population > (
  SELECT gdp/population
  FROM world
  WHERE name = 'United Kingdom');

-- # 4. Which country has a population that is more than Canada but
-- # less than Poland? Show the name and the population.
SELECT name, population
FROM world
WHERE population > 
(SELECT population FROM world WHERE name = 'Canada')
AND population < 
(SELECT population FROM world WHERE name = 'Poland');

-- # 5. Which countries have a GDP greater than any country in Europe?
-- # [Give the name only.]
SELECT name
FROM world
WHERE gdp > (
  SELECT MAX(gdp)
  FROM world
  WHERE continent = 'Europe');
                 
-- # 5. [NEW] Show the name and the population of each country in Europe. 
-- # Show the population as a percentage of the population of Germany.
SELECT name, CONCAT(ROUND(population/(SELECT population FROM world WHERE name = 'Germany')*100),'%')
FROM world
WHERE continent = 'Europe';

-- # 6. Which countries have a GDP greater than every country in Europe? 
-- # [Give the name only.] (Some countries may have NULL gdp values)
SELECT name 
FROM world
WHERE gdp > ALL(SELECT gdp FROM world WHERE gdp > 0 AND continent = 'Europe');
                 
-- # 7. Find the largest country (by area) in each continent, show the 
-- # continent, the name and the area.
SELECT x.continent, x.name, x.area
FROM world AS x
WHERE x.area = (
  SELECT MAX(y.area)
  FROM world AS y
  WHERE x.continent = y.continent)
                 
--[2nd way to solve]
 SELECT continent, name, area
FROM world AS x
WHERE area >= ALL(SELECT area 
                  FROM world AS y 
                  WHERE x.continent = y.continent 
                  AND y.area > 0); 

-- # 8. List each continent and the name of the country that comes first alphabetically.
--[1st way]
SELECT continent,name
FROM world AS x
WHERE name = (SELECT name 
              FROM world AS y 
              WHERE x.continent=y.continent 
              ORDER BY name ASC 
              LIMIT 1);                 
--[2nd way]
SELECT continent, MIN(name) AS name
FROM world 
GROUP BY continent
ORDER by continent;
                 
-- # 9. Find each country that belongs to a continent where all
-- # populations are less than 25000000. Show name, continent and
-- # population.
-- # [1st way]
SELECT x.name, x.continent, x.population
FROM world AS x
WHERE 25000000 > ALL (
  SELECT y.population
  FROM world AS y
  WHERE x.continent = y.continent);
-- # [2nd way]
SELECT x.name, x.continent, x.population
FROM world AS x
JOIN (SELECT continent, MAX(population)
FROM world
GROUP BY continent
HAVING MAX(population) <= 25000000) AS y
ON y.continent = x.continent;                 
-- # [3rd way]
SELECT name, continent, population 
FROM world 
WHERE continent IN (SELECT continent 
                    FROM world AS x 
                    WHERE 25000000 >= (SELECT MAX(population) 
                                       FROM world y 
                                       WHERE x.continent = y.continent));
                 
-- # 10. Some countries have populations more than three times that of
-- # any of their neighbours (in the same continent). Give the
-- # countries and continents.
-- [1st way]
SELECT x.name, x.continent
FROM world AS x
WHERE x.population/3 > ALL (
  SELECT y.population
  FROM world AS y
  WHERE x.continent = y.continent
  AND x.name != y.name);

 -- [2nd way]
 SELECT name, continent
FROM world AS x
WHERE x.population >= ALL(SELECT 3*population 
                          FROM world AS y 
                          WHERE y.continent=x.continent 
                          AND x.name != y.name);                                      
