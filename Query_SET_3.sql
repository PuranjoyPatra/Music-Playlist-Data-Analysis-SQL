--- Select Database
use DAMusicPlaylist;


--1. Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent

WITH best_selling_artist AS (
	SELECT TOP 1 ART.artist_id AS Artist_ID, ART.name AS Artist_Name,
	SUM(IL.unit_price*IL.quantity) AS Total_Sales
	FROM invoice_line IL
	JOIN track TR ON TR.track_id = IL.track_id
	JOIN album AL ON AL.album_id = TR.album_id
	JOIN artist ART ON ART.artist_id = AL.artist_id
	GROUP BY ART.artist_id, ART.name
	ORDER BY Total_Sales DESC
)

SELECT CUST.customer_id, first_name, last_name, BSA.Artist_Name,
SUM(IL.unit_price*IL.quantity) AS Amount_Spent
FROM customer CUST
JOIN invoice INV ON INV.customer_id = CUST.customer_id
JOIN invoice_line IL ON IL.invoice_id = INV.invoice_id
JOIN track TR ON TR.track_id = IL.track_id
JOIN album AL ON AL.album_id = TR.album_id
JOIN best_selling_artist BSA ON BSA.Artist_ID = AL.artist_id
GROUP BY CUST.customer_id, first_name, last_name, BSA.Artist_Name
ORDER BY 5 DESC



--2. We want to find out the most popular music Genre for each country. We determine the 
--most popular genre as the genre with the highest amount of purchases. Write a query 
--that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY customer.country, genre.name, genre.genre_id
)
SELECT * FROM popular_genre WHERE RowNo = 1
ORDER BY country ASC, purchases DESC



/* Method 2: : Using Recursive */

WITH sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY customer.country, genre.name, genre.genre_id
		
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY country
		)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number
ORDER BY sales_per_country.country



--3. Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amoun

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY customer.customer_id,first_name,last_name,billing_country
		)
SELECT * FROM Customter_with_country WHERE RowNo <= 1
ORDER BY 4 ASC,5 DESC


/* Method 2: Using Recursive */

WITH customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY customer.customer_id,first_name,last_name,billing_country
		),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country C
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;
