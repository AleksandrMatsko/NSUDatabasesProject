WITH l_halls AS (
	SELECT hall_id FROM "public.Libraries" L
	INNER JOIN "public.Halls" H
	ON H.library_id = L.library_id
	WHERE L.name = 'Новосибирская государственная областная научная библиотека'
)

SELECT last_name, first_name, patronymic FROM "public.Librarians" L
INNER JOIN l_halls
ON L.hall_id = l_halls.hall_id
WHERE L.hall_id = 1 AND date_retired IS NULL