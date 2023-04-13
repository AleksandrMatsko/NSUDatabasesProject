WITH l_halls AS (
	SELECT hall_id FROM "public.Libraries" L
	INNER JOIN "public.Halls" H
	ON H.library_id = L.library_id
	WHERE L.name = 'Новосибирская государственная областная научная библиотека'
), examples AS (
	SELECT stored_id, book_id FROM "public.StorageInfo" SI
	INNER JOIN l_halls
	ON l_halls.hall_id = SI.hall_id
	WHERE l_halls.hall_id = 2 AND bookcase = 3 AND shelf = 2
), issued AS (
	SELECT DISTINCT book_id FROM examples e
	INNER JOIN "public.IssueJournal" IJ
	ON IJ.stored_id = e.stored_id
	WHERE IJ.date_return IS NULL
)

SELECT "name" FROM "public.Books" B
INNER JOIN issued
ON B.book_id = issued.book_id