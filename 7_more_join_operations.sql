-- # 1. List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr = 1962;

-- # 2. Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- # 3-1. List all of the Star Trek movies, include the id, title and yr
-- # (all of these movies include the words Star Trek in the
-- # title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- # 3-2. What are the titles of the films with id 11768, 11955, 21191.
SELECT title
FROM movie
WHERE id IN (11768, 11955, 21191);

-- # 4. What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- # 5. What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- # 6. Obtain the cast list for 'Casablanca'. Use the id value that
-- # you obtained in the previous question.
SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.movieid = 11768;

-- # 7. Obtain the cast list for the film 'Alien'.
SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
JOIN movie
ON movie.id = casting.movieid
WHERE movie.title = 'Alien';

-- # 8. List the films in which 'Harrison Ford' has appeared
SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';

-- # 9. List the films where 'Harrison Ford' has appeared - but not in
-- # the star role. [Note: the ord field of casting gives the position
-- # of the actor. If ord=1 then this actor is in the starring role]
SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford'
AND casting.ord != 1;

-- # 10. List the films together with the leading star for all 1962 films.
SELECT movie.title, actor.name
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE movie.yr = 1962
AND casting.ord = 1;

-- # 11. Which were the busiest years for 'John Travolta', show the
-- # year and the number of movies he made each year for any year in
-- # which he made at least 2 movies.
SELECT movie.yr, COUNT(*)
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'John Travolta'
GROUP BY movie.yr
HAVING COUNT(movie.title) >= 2;

-- # 12. List the film title and the leading actor for all of 'Julie
-- # Andrews' films.
SELECT DISTINCT m.title, a.name
FROM (SELECT movie.*
      FROM movie
      JOIN casting
      ON casting.movieid = movie.id
      JOIN actor
      ON actor.id = casting.actorid
      WHERE actor.name = 'Julie Andrews') AS m
JOIN (SELECT actor.*, casting.movieid AS movieid
      FROM actor
      JOIN casting
      ON casting.actorid = actor.id
      WHERE casting.ord = 1) as a
ON m.id = a.movieid
ORDER BY m.title;

-- # 13. Obtain a list of actors in who have had at least 30 starring
-- # roles.
SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.ord = 1
GROUP BY actor.name
HAVING COUNT(*) >= 30;

-- # 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(name)
FROM casting JOIN movie ON movieid=movie.id JOIN actor ON actorid=actor.id
WHERE yr = 1978
GROUP BY title
ORDER by COUNT(name) DESC,title;

-- # 15. List all the people who have worked with 'Art Garfunkel'.
-- [1st way]
SELECT a.name
  FROM (SELECT movie.*
          FROM movie
          JOIN casting
            ON casting.movieid = movie.id
          JOIN actor
            ON actor.id = casting.actorid
         WHERE actor.name = 'Art Garfunkel') AS m
  JOIN (SELECT actor.*, casting.movieid
          FROM actor
          JOIN casting
            ON casting.actorid = actor.id
         WHERE actor.name != 'Art Garfunkel') as a
    ON m.id = a.movieid;
    
-- [2nd way]    
SELECT DISTINCT(name)
FROM casting JOIN movie ON movieid=movie.id JOIN actor ON actorid=actor.id
WHERE title IN (SELECT title 
                FROM casting JOIN movie ON movieid=movie.id JOIN actor ON actorid=actor.id
                WHERE name = 'Art Garfunkel')
            AND name !='Art Garfunkel';    
