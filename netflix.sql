DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(10),
    title        VARCHAR(150),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(150),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(100),
    description  VARCHAR(250)
);


-- Warming Up --
--- Project ---
SELECT * FROM netflix;

--- Checking Total Movies ---
SELECT COUNT(*) as Total_movies
FROM netflix


-- Business Problems and Solutions --

--- 1. Count the number of Movies Vs TV Shows

SELECT type, COUNT(*) 
FROM netflix
GROUP BY type;

--- 2. Find the most common rating for movies and TV Shows
SELECT
	type,
	rating
FROM

(SELECT
	type,
	rating,
	COUNT(*) AS rating_count,
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS Ranking
FROM netflix
GROUP BY type, rating) as t1
WHERE
	Ranking = 1

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * 
FROM netflix
WHERE 
	type = 'Movie' AND
	release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS new_country,
	COUNT(show_id) as Total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the Longest Movie
SELECT *
FROM netflix 
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)

-- 6. Find Content Added in the Last 5 Years

SELECT
	*
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

	
-- 7. Find All Movies/TV Shows by Director 'Mike Flanagan'
SELECT * 
FROM netflix
WHERE director = 'Mike Flanagan'

-- 8. List All TV Shows with More Than 5 Seasons
SELECT
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1) :: numeric > 5
	
-- 9. Count the Number of Content Items in Each Genre
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS Genre,
	COUNT(show_id) as Total_content
FROM netflix
GROUP BY 1;


-- 10.Find each year and the average numbers of content release in Indonesia on netflix.
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*),
	ROUND(
		COUNT(*)::Numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'Indonesia'),
			2) ::Numeric * 100 as avg_content_per_year
FROM netflix
WHERE country = 'Indonesia'
GROUP BY 1
ORDER BY 3 DESC;

-- 11. List All Movies that are Documentaries
SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries%'

-- 12. Find All Content Without a Director
SELECT *
FROM netflix
WHERE
	director IS NULL

-- 13. Find How Many Movies Actor 'Reza Rahadian' Appeared in the Last 10 Years
SELECT *
FROM netflix
WHERE
	casts ILIKE '%Reza Rahadian%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in Indonesia
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY (casts, ','))) as Actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%Indonesia%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
WITH new_table
AS
(
SELECT 
	*,
	CASE
	WHEN 
		description ILIKE '%kill%' OR 
		description ILIKE '%Violence%' THEN 'Bad Content'
		ELSE 'Good Content'
	END category
FROM netflix
)
SELECT
	category,
	count(*) as total_content
FROM new_table
GROUP BY 1
