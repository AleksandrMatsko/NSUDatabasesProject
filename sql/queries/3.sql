WITH examples AS (
	SELECT stored_id FROM "public.StorageInfo" SI
	INNER JOIN "public.Books" B
	ON SI.book_id = B.book_id
	WHERE B.name = 'Евгений Онегин'
), uids AS (
	SELECT user_id FROM "public.IssueJournal" IJ
	INNER JOIN examples 
	ON IJ.stored_id = examples.stored_id
	WHERE IJ.date_return IS NULL
)

SELECT last_name, first_name, patronymic FROM "public.Users" U
INNER JOIN uids
ON uids.user_id = U.user_id



