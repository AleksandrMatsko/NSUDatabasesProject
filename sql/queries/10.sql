WITH durations AS (
	SELECT user_id, date_issue + duration_issue AS exp_date, date_return FROM "public.StorageInfo" SI
	INNER JOIN "public.IssueJournal" IJ
	ON IJ.stored_id = SI.stored_id
	WHERE available_issue
), debtors AS (
	SELECT DISTINCT user_id FROM durations
	WHERE (date_return IS NOT NULL AND exp_date < date_return) OR (date_return IS NULL AND exp_date < NOW())
)

SELECT last_name, first_name, patronymic FROM "public.Users" U
INNER JOIN debtors
ON U.user_id = debtors.user_id
