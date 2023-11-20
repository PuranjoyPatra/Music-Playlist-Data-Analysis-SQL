--- Select Database
use DAMusicPlaylist;

--1. Write query to return the email, first name, last name, & Genre of all Rock Music 
--listeners. Return your list ordered alphabetically by email starting with A

SELECT distinct first_name, last_name, email FROM customer CUST
JOIN invoice INV ON CUST.customer_id = INV.customer_id
JOIN invoice_line INL ON INV.invoice_id = INL.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track TR
	JOIN genre GEN ON TR.genre_id = GEN.genre_id
	WHERE GEN.name LIKE'Rock'
)
ORDER BY email



--2. Let's invite the artists who have written the most rock music in our dataset. Write a 
--query that returns the Artist name and total track count of the top 10 rock bands
SELECT TOP 10 ART.artist_id, ART.name, COUNT(ART.artist_id) AS NumberOfSong FROM track TR
JOIN album AL ON TR.album_id = AL.album_id
JOIN artist ART ON ART.artist_id = AL.artist_id
JOIN genre GEN ON GEN.genre_id = TR.genre_id
WHERE GEN.name LIKE 'Rock'
GROUP BY ART.name, ART.artist_id
ORDER BY NumberOfSong DESC


--3. Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the 
--longest songs listed first

SELECT name, milliseconds FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS Avg_Song_Length FROM track
)
ORDER BY milliseconds DESC