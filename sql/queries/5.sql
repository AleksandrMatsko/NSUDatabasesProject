WITH uid_lib AS (
	SELECT U.user_id, library_id FROM "public.Users" U
	INNER JOIN "public.RegistrationJournal" RJ
	ON RJ.user_id = U.user_id
	WHERE last_name = 'Мацько' AND first_name = 'Александр' AND patronymic = 'Михайлович'
), lib_halls AS (
	SELECT hall_id FROM "public.Halls" H
	INNER JOIN uid_lib
	ON H.library_id = uid_lib.library_id
), examples AS (
	SELECT stored_id FROM "public.IssueJournal" IJ
	INNER JOIN uid_lib
	ON IJ.user_id = uid_lib.user_id
	WHERE IJ.date_issue >= '2016-01-01' AND IJ.date_issue <= '2022-12-31'
), books AS (
	SELECT book_id, hall_id FROM examples
	INNER JOIN "public.StorageInfo" SI
	ON SI.stored_id = examples.stored_id
), lib_books AS (
	SELECT book_id FROM books
	INNER JOIN lib_halls
	ON books.hall_id = lib_halls.hall_id
)

SELECT "name" FROM "public.Books" B
INNER JOIN lib_books
ON B.book_id = lib_books.book_id


