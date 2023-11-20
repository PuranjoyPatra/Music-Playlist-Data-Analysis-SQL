-- select database
use DAMusicPlaylist;

--1. Who is the senior most employee based on job title?

SELECT TOP 1 *
FROM employee
ORDER BY levels DESC


--2. Which countries have the most Invoices?
SELECT billing_country, COUNT(invoice_id) as TotalInvoice
FROM invoice
GROUP BY billing_country
ORDER BY TotalInvoice DESC



--3. What are top 3 values of total invoice?
SELECT TOP 3 ROUND(total,2) AS Total_Value
FROM invoice
ORDER BY total DESC



--4. Which city has the best customers? We would like to throw a promotional Music 
--Festival in the city we made the most money. Write a query that returns one city that 
--has the highest sum of invoice totals. Return both the city name & sum of all invoice 
--totals

SELECT billing_city, SUM(total) as SumTotal
FROM invoice
GROUP BY billing_city
ORDER BY SumTotal DESC

--5. Who is the best customer? The customer who has spent the most money will be 
--declared the best customer. Write a query that returns the person who has spent the 
--most money

SELECT TOP 1 CUST.customer_id, first_name, last_name, SUM(total) AS InvoiceTotal FROM customer CUST
INNER JOIN invoice INV
ON INV.customer_id = CUST.customer_id
GROUP BY CUST.customer_id, first_name, last_name
ORDER BY InvoiceTotal DESC


