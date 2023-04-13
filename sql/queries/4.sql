WITH in_books AS (
	SELECT book_id FROM "public.LiteraryWorks" LW
	INNER JOIN "public.WorksInBook" WB
	ON LW.lw_id = WB.lw_id
	WHERE LW.name = 'Евгений Онегин'
), b_names AS (
	SELECT B.book_id, "name" FROM "public.Books" B
	INNER JOIN in_books
	ON in_books.book_id = B.book_id
), examples AS (
	SELECT stored_id, "name" b_name FROM "public.StorageInfo" SI
	INNER JOIN b_names
	ON SI.book_id = b_names.book_id
), uids AS (
	SELECT user_id, b_name FROM "public.IssueJournal" IJ
	INNER JOIN examples 
	ON IJ.stored_id = examples.stored_id
	WHERE IJ.date_issue >= '2016-01-01' AND IJ.date_issue <= '2022-12-31'
)

SELECT last_name, first_name, patronymic, b_name FROM "public.Users" U
INNER JOIN uids
ON uids.user_id = U.user_id



