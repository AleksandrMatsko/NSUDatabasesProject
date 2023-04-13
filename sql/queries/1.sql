SELECT last_name, first_name, patronymic FROM "public.Users" U
INNER JOIN "public.Students" S
ON U.user_id = S.user_id
WHERE faculty = 'ФИТ'
ORDER BY last_name, first_name, patronymic