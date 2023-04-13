WITH num_users_iss AS (
	SELECT issued_by_lbrn AS librarian_id, COUNT(user_id) AS num FROM "public.IssueJournal" IJ
	WHERE '2016-01-01' <= IJ.date_issue AND IJ.date_issue <= '2022-12-31' 
	GROUP BY issued_by_lbrn
), num_users_accept AS (
	SELECT accepted_by_lbrn AS librarian_id, COUNT(user_id) AS num FROM "public.IssueJournal" IJ
	WHERE date_return IS NOT NULL AND '2016-01-01' <= date_return AND date_return <= '2022-12-31' 
	GROUP BY accepted_by_lbrn
), num_users_reg AS (
	SELECT librarian_id, COUNT(user_id) AS num FROM "public.RegistrationJournal" RJ
	WHERE '2016-01-01' <= registration_date AND registration_date <= '2022-12-31'
	GROUP BY librarian_id
), num_users_UN AS (
	SELECT * FROM num_users_iss
	UNION ALL SELECT * FROM num_users_reg
	UNION ALL SELECT * FROM num_users_accept
), num_users AS (
	SELECT librarian_id, SUM(num) AS num FROM num_users_UN
	GROUP BY librarian_id
)

SELECT last_name, first_name, patronymic,
CASE WHEN num IS NULL THEN 
	0 
	ELSE num 
END AS num
FROM "public.Librarians" L
LEFT JOIN num_users
ON num_users.librarian_id = L.librarian_id