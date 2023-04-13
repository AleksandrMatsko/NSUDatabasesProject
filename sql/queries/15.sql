WITH lworks AS (
	SELECT lw_id FROM "public.Authors" AU
	INNER JOIN "public.AuthorsWorks" AW
	ON AU.author_id = AW.author_id
	WHERE last_name = 'Пушкин' AND first_name = 'Александр' AND patronymic = 'Сергеевич'
), books AS (
	SELECT DISTINCT book_id FROM lworks
	INNER JOIN "public.WorksInBook" WB
	ON lworks.lw_id = WB.lw_id
), book_names AS (
	SELECT B.book_id, "name" FROM "public.Books" B
	INNER JOIN books
	ON B.book_id = books.book_id
)

SELECT stored_id, "name" FROM "public.StorageInfo" SI
INNER JOIN book_names
ON SI.book_id = book_names.book_id