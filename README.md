# Netflix Data Analysis Using SQL
![](https://github.com/playingwithdata-and/Netflix_sql_project/blob/main/Logo.jpg)

# 📊 Netflix Data Analysis Using SQL

This repository contains SQL queries designed to analyze and uncover insights from the Netflix dataset. The analysis includes various business problems such as identifying the most common content types, popular ratings, country-based content distribution, and more.

## Preview

![Netflix Movies and TV Shows Dashboard Preview](https://github.com/playingwithdata-and/Netflix-data-analysis/blob/main/Netflix%20Dashboard.png)

## 📝 Project Overview

The Netflix dataset is analyzed to address several business questions and objectives, ranging from content trends, genre popularity, to specific director and actor analyses. This project demonstrates how SQL can be used to extract insights and solve real-world business problems.

## 📂 Dataset Description
About this Dataset: Netflix is one of the most popular media and video streaming platforms. They have over 8000 movies or tv shows available on their platform, as of mid-2021, they have over 200M Subscribers globally. This tabular dataset consists of listings of all the movies and tv shows available on Netflix, along with details such as - cast, directors, ratings, release year, duration, etc.
  **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## 📂 Dataset Structure

The Netflix dataset consists of the following columns:
- **show_id**: Unique identifier for the content
- **type**: Movie or TV Show
- **title**: Title of the content
- **director**: Director's name
- **casts**: Main actors/actresses in the content
- **country**: Country of origin
- **date_added**: Date when the content was added to Netflix
- **release_year**: Year the content was released
- **rating**: Age rating of the content
- **duration**: Duration of the content (in minutes or seasons)
- **listed_in**: Genres or categories the content belongs to
- **description**: Brief description of the content

## 🎯 Analysis Objectives


### 🔧 SQL Queries

#### 1. Create Netflix Table
```sql
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
```

### Business Problems and Solutions
### Business Problems and Solutions

#### 1. Count the number of Movies Vs TV Shows
```sql
SELECT type, COUNT(*) 
FROM netflix
GROUP BY type;
```

#### 2. Find the most common rating for movies and TV Shows
```sql
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
```
#### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT * 
FROM netflix
WHERE 
	type = 'Movie' AND
	release_year = 2020;
```
#### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS new_country,
	COUNT(show_id) as Total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

#### 5. Identify the Longest Movie
```sql
SELECT *
FROM netflix 
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)
```

#### 6. Find Content Added in the Last 5 Years
```sql
SELECT
	*
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```
	
#### 7. Find All Movies/TV Shows by Director 'Mike Flanagan'
```sql
SELECT * 
FROM netflix
WHERE director = 'Hanung Bramantyo'```
```

#### 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1) :: numeric > 5
```

#### 9. Count the Number of Content Items in Each Genre
```sql
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS Genre,
	COUNT(show_id) as Total_content
FROM netflix
GROUP BY 1;
```

#### 10.Find each year and the average numbers of content release in Indonesia on netflix.
```sql
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
```
#### 11. List All Movies that are Documentaries
```sql
SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries%'
```
#### 12. Find All Content Without a Director
```sql
SELECT *
FROM netflix
WHERE
	director IS NULL

## 13. Find How Many Movies Actor 'Reza Rahadian' Appeared in the Last 10 Years
SELECT *
FROM netflix
WHERE
	casts ILIKE '%Reza Rahadian%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```
#### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in Indonesia
```sql
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY (casts, ','))) as Actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%Indonesia%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

#### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
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
```

## Author - Playingwithdata - Andre

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
