SELECT DISTINCT "name" FROM "public.StorageInfo" SI
INNER JOIN "public.Books" B
ON B.book_id = SI.book_id
WHERE '2018-01-01' <= date_receipt AND date_receipt <= '2022-12-31'