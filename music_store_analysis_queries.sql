--Q1. Identify the most senior employee in the organization.
select first_name||' '||last_name as name, title from employee
order by levels desc
limit 1;


--Q2.Find the number of invoices generated in each billing country.
select count(invoice_id) As total_invoice,billing_country 
from invoice
group by billing_country
order by total_invoice desc;

--Q3.Identify the highest invoice totals in the database.
select total from invoice
order by total desc
limit 3;

--Q4.Determine which city generated the highest total invoice revenue.
select sum(total) as total_invoice,billing_city from invoice
group by billing_city
order by total_invoice desc
limit 1;

--Q5.Identify the customer who spent the most money.
select c.first_name,c.last_name,sum(i.total) as total_spend
from customer c
inner join invoice i
on c.customer_id=i.customer_id
group by c.customer_id
order by total_spend desc
limit 1; 

--Q6.Find customers who purchased tracks from the Rock genre.
select distinct
c.email,
c.first_name,
c.last_name,
g.name
from customer c
join invoice i
	on c.customer_id=i.customer_id
join invoice_line il
	on i.invoice_id=il.invoice_id
join track t
	on il.track_id=t.track_id
join genre g
	on t.genre_id=g.genre_id
where g.name='Rock' 
order by c.email asc;

--Q7.Identify top 10 artists who have the highest number of Rock tracks
select ar.name,count(ar.artist_id) as track_count
from artist ar
join album a
	on ar.artist_id=a.artist_id
join track t
	on a.album_id=t.album_id
join genre g
	on t.genre_id=g.genre_id
	where g.name='Rock'
group by ar.artist_id,ar.name
order by track_count desc
limit 10;

--Q8.Find tracks that are longer than the average track length
with avg_len as
(select avg(milliseconds)
as avg_song_length
from track
)
select t.name,t.milliseconds,a.avg_song_length
from track t
cross join avg_len a
where t.milliseconds>a.avg_song_length
order by milliseconds desc;

--Q9.Calculate how much each customer has spent on different artists.
select
    c.first_name || ' ' || c.last_name as customer_name,
    ar.name as artist_name,
    sum(il.unit_price * il.quantity) as total_spent
from customer c
join invoice i
    on c.customer_id = i.customer_id
join invoice_line il
    on i.invoice_id = il.invoice_id
join track t
    on il.track_id = t.track_id
join album a
    on t.album_id = a.album_id
join artist ar
    on a.artist_id = ar.artist_id
group by
    c.customer_id,
    c.first_name,
    c.last_name,
    ar.artist_id,
    ar.name
order by total_spent desc
limit 10;

--Q10.Determine the most popular music genre in each country.

with popular_genre as
(
select count(il.quantity) as purchase,i.billing_country,g.name,
row_number() over(partition by i.billing_country order by count(il.quantity) desc ) as row_number
from invoice i
join invoice_line il
on i.invoice_id=il.invoice_id
join track t
on il.track_id=t.track_id
join genre g
on t.genre_id=g.genre_id
group by i.billing_country,g.name,il.quantity 
)
select purchase,billing_country,name from popular_genre where row_number=1;


