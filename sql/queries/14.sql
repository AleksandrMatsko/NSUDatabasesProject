WITH books AS (
	SELECT book_id FROM "public.LiteraryWorks" LW
	INNER JOIN "public.WorksInBook" WB
	ON LW.lw_id = WB.lw_id
	WHERE LW.name = 'Евгений Онегин'
), book_names AS (
	SELECT B.book_id, "name" FROM "public.Books" B
	INNER JOIN books
	ON B.book_id = books.book_id
)

SELECT stored_id, "name" FROM "public.StorageInfo" SI
INNER JOIN book_names
ON SI.book_id = book_names.book_id