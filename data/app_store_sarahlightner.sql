SELECT ROUND(AVG(review_count),2)
FROM play_store_apps --444152.9

SELECT ROUND(AVG(review_count::numeric),2)
FROM app_store_apps --12892.91

--We chose the top 10 according to price, rating, and genre. The rating had to be higher than a 4, assuming that high ratings meant a high
--probabilty of of the app being worthwhile for consumers. We then said that the app must have a content rating of at least 4+, since a majority
--of users can navigate said app. Price was the primary reasoning. We chose apps that did not cost anything. Doing this allowed for only the price 
--stipulation to be 25,000, instead of an extra 10,000 per dollar. We then added up the total cost and the minimum amount of income per year. 
--We took notice that the apps top genres are games.
SELECT DISTINCT name, app_store_apps.price AS app_price, app_store_apps.rating AS app_rating , app_store_apps.content_rating AS app_content_rating, play_store_apps.price AS play_price, play_store_apps.rating AS play_rating, primary_genre AS app_genre, genres AS play_genre,
play_store_apps.content_rating AS play_content_rating
FROM app_store_apps
	INNER JOIN play_store_apps USING (name)
WHERE app_store_apps.review_count::numeric >12892.91 AND play_store_apps.review_count::numeric > 444152.90 AND app_store_apps.rating > 4 AND app_store_apps.price = 0.00 AND app_store_apps.content_rating = '4+'
ORDER BY play_store_apps.rating DESC, app_store_apps.rating DESC;

--TOP 10
--"Domino's Pizza USA"
--"Egg, Inc."
--"Bible"
--"Toy Blast"
--"Chase Mobile"
--"Fishdom"
--"Geometry Dash Meltdown"
--"Score! Hero"
--"Township"
--"Geometry Dash Lite"

---------------------------------------------------------------------------------------------
--Based on Rating, Review Count, and price, we chose the 4 Halloween themed games most appropriate.

WITH table_a AS (SELECT name, content_rating, rating, review_count::integer, price::numeric, (4000*12) AS min_gross_rev_year1,
	CASE WHEN price::numeric BETWEEN 0 AND 2.50 THEN 25000
	   ELSE price *10000
		 END AS total_cost_year1
FROM app_store_apps
WHERE app_store_apps.name ILIKE '%Halloween%' OR app_store_apps.name ILIKE '%HAUNTED%' AND rating >= 4.0
	UNION
SELECT name, content_rating, rating, review_count, price::numeric, (4000*12) AS min_gross_rev,
	CASE WHEN price::numeric BETWEEN 0 AND 2.50 THEN 25000
	    ELSE price::numeric *10000
		END AS total_cost_year1
FROM play_store_apps
WHERE play_store_apps.name ILIKE '%Halloween%' OR play_store_apps.name ILIKE '%HAUNTED%' and rating >= 4.0
ORDER BY review_count DESC, rating DESC, price::numeric)
SELECT name, content_rating,
rating, review_count::integer,
price::numeric, 
(4000*12) AS min_gross_rev_year1, 
total_cost_year1, 
min_gross_rev_year1 - total_cost_year1 AS profit_year1
FROM table_a

--"Haunted Halloween Escape"
--"Connect'Em Halloween"
--"Coin Dozer: Haunted"
--"Halloween Sandbox Number Coloring- Color By Number"


