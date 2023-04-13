WITH in_books AS (
	SELECT book_id FROM "public.LiteraryWorks" LW
	INNER JOIN "public.WorksInBook" WB
	ON LW.lw_id = WB.lw_id
	WHERE LW.name = 'Хромая судьба'
), examples AS (
	SELECT stored_id FROM "public.StorageInfo" SI
	INNER JOIN in_books
	ON SI.book_id = in_books.book_id
), uids AS (
	SELECT user_id FROM "public.IssueJournal" IJ
	INNER JOIN examples 
	ON IJ.stored_id = examples.stored_id
	WHERE IJ.date_return IS NULL
)

SELECT last_name, first_name, patronymic FROM "public.Users" U
INNER JOIN uids
ON uids.user_id = U.user_id



