package ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;

import java.util.Date;
import java.util.List;

@Repository
public interface LibrarianRepository extends JpaRepository<LibrarianEntity, Integer> {

    // query 9
    @Query(value = """           
            WITH num_users_iss AS (
            	SELECT issued_by_lbrn AS librarian_id, COUNT(user_id) AS num FROM "public.IssueJournal" IJ
            	WHERE :start_date <= IJ.date_issue AND IJ.date_issue <= :end_date
            	GROUP BY issued_by_lbrn
            ), num_users_accept AS (
            	SELECT accepted_by_lbrn AS librarian_id, COUNT(user_id) AS num FROM "public.IssueJournal" IJ
            	WHERE date_return IS NOT NULL AND :start_date <= date_return AND date_return <= :end_date
            	GROUP BY accepted_by_lbrn
            ), num_users_reg AS (
            	SELECT librarian_id, COUNT(user_id) AS num FROM "public.RegistrationJournal" RJ
            	WHERE :start_date <= registration_date AND registration_date <= :end_date
            	GROUP BY librarian_id
            ), num_users_UN AS (
            	SELECT * FROM num_users_iss
            	UNION ALL SELECT * FROM num_users_reg
            	UNION ALL SELECT * FROM num_users_accept
            ), num_users AS (
            	SELECT librarian_id, SUM(num) AS num FROM num_users_UN
            	GROUP BY librarian_id
            )
                        
            SELECT L.librarian_id AS librarianId,
            CASE WHEN num IS NULL THEN
            	0
            	ELSE num
            END AS numUsers
            FROM "public.Librarians" L
            LEFT JOIN num_users
            ON num_users.librarian_id = L.librarian_id
            """, nativeQuery = true)
    List<LibrarianWithNumUsers> findReports(
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);


    // query 12
    @Query(value = """                        
            WITH l_halls AS (
            	SELECT hall_id FROM "public.Libraries" L
            	INNER JOIN "public.Halls" H
            	ON H.library_id = L.library_id
            	WHERE L.name ILIKE '%' || :libraryName || '%'
            )
                        
            SELECT L.librarian_id FROM "public.Librarians" L
            INNER JOIN l_halls
            ON L.hall_id = l_halls.hall_id
            WHERE L.hall_id = :hallId AND date_retired IS NULL
            """, nativeQuery = true)
    List<Integer> findByLibraryAndHall(
            @Param("libraryName") String libraryName,
            @Param("hallId") Integer hallId);

    @Query(value = """
            DELETE FROM public."public.Librarians"
            	WHERE librarian_id = :id RETURNING librarian_id;
            """, nativeQuery = true)
    Integer deleteLibrarianById(@Param("id") Integer id);
}
