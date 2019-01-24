with tb as (SELECT strftime('%Y', invoices.InvoiceDate) as year, artists.Name, sum(invoice_items.Quantity * invoice_items.UnitPrice) as mostPurchased
	FROM invoices
	JOIN invoice_items ON invoices.InvoiceId = invoice_items.InvoiceId
	JOIN tracks ON invoice_items.TrackId = tracks.TrackId
	JOIN albums ON tracks.AlbumId = albums.AlbumId
	JOIN artists ON albums.ArtistId = artists.ArtistId
	WHERE BillingState = 'CA' 
	GROUP BY 1, 2)
select year, name, mostPurchased
from tb as tb1
where year || name in
	(select year || name 
	from tb as tb2
	where tb1.year = tb2.year
	order by mostPurchased DESC
	LIMIT 3)
order by year, mostPurchased desc