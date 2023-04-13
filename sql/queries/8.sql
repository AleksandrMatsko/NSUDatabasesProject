WITH librn AS (
	SELECT librarian_id FROM "public.Librarians" L
	WHERE last_name = 'Букварёв' AND first_name = 'Иван' AND patronymic = 'Александрович'
), users AS (
	SELECT DISTINCT user_id FROM "public.IssueJournal" IJ, librn
	WHERE (('2010-12-31' < date_issue AND date_issue < '2022-01-01') OR 
		(date_return IS NOT NULL AND '2010-12-31' < date_return AND date_return < '2022-01-01')) AND 
		(IJ.issued_by_lbrn = librn.librarian_id OR IJ.accepted_by_lbrn = librn.librarian_id)
	UNION SELECT user_id FROM "public.RegistrationJournal" RJ, librn
	WHERE '2010-12-31' < registration_date AND registration_date < '2022-01-01' AND
		RJ.librarian_id = librn.librarian_id
)

SELECT last_name, first_name, patronymic FROM "public.Users" U
INNER JOIN users
ON U.user_id = users.user_id

