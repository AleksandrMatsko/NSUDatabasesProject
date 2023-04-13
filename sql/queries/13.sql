WITH users AS (
	SELECT DISTINCT user_id FROM "public.IssueJournal" IJ
	WHERE (date_issue < '2022-01-01' AND date_issue > '2020-12-31') OR 
		(date_return IS NOT NULL AND date_return < '2022-01-01' AND date_return > '2020-12-31')	
	UNION SELECT DISTINCT user_id FROM "public.RegistrationJournal" RJ
	WHERE registration_date < '2022-01-01' AND registration_date > '2020-12-31'
)

SELECT last_name, first_name, patronymic FROM "public.Users" U
WHERE U.user_id NOT IN(SELECT users.user_id FROM users)