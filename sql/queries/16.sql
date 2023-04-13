WITH issue_cnts AS (
	SELECT stored_id, COUNT(stored_id) AS s_cnt FROM "public.IssueJournal"
	GROUP BY stored_id
), book_cnts AS (
	SELECT book_id, SUM(s_cnt) as bk_cnt FROM issue_cnts
	INNER JOIN "public.StorageInfo" SI
	ON SI.stored_id = issue_cnts.stored_id
	GROUP BY book_id
), lw_cnts AS (
	SELECT lw_id, bk_cnt AS cnt FROM "public.WorksInBook" WIB
	INNER JOIN book_cnts
	ON WIB.book_id = book_cnts.book_id
)

SELECT "name", lw_cnts.cnt FROM lw_cnts
RIGHT JOIN "public.LiteraryWorks" LW
ON LW.lw_id = lw_cnts.lw_id
ORDER BY lw_cnts.cnt DESC NULLS LAST, "name" ASC
LIMIT 10