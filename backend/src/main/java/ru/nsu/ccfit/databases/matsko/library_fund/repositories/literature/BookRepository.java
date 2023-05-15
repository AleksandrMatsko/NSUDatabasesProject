package ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;

import java.util.Date;
import java.util.List;

public interface BookRepository extends JpaRepository<BookEntity, Integer> {

    // query 5
    @Query(value = """           
            WITH uid_lib AS (
            	SELECT U.user_id, library_id FROM "public.Users" U
            	INNER JOIN "public.RegistrationJournal" RJ
            	ON RJ.user_id = U.user_id
            	WHERE U.user_id = :uid
            ), lib_halls AS (
            	SELECT hall_id FROM "public.Halls" H
            	INNER JOIN uid_lib
            	ON H.library_id = uid_lib.library_id
            ), examples AS (
            	SELECT stored_id FROM "public.IssueJournal" IJ
            	INNER JOIN uid_lib
            	ON IJ.user_id = uid_lib.user_id
            	WHERE IJ.date_issue >= :start_date AND IJ.date_issue <= :end_date
            ), books AS (
            	SELECT book_id, hall_id FROM examples
            	INNER JOIN "public.StorageInfo" SI
            	ON SI.stored_id = examples.stored_id
            )

            SELECT book_id FROM books
            INNER JOIN lib_halls
            ON books.hall_id = lib_halls.hall_id;
            """, nativeQuery = true)
    List<Integer> findBooksByUserIdAndPeriodFromRegLib(
            @Param("uid") Integer id,
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);

    // query 6
    @Query(value = """           
            WITH uid_lib AS (
            	SELECT U.user_id, library_id FROM "public.Users" U
            	INNER JOIN "public.RegistrationJournal" RJ
            	ON RJ.user_id = U.user_id
            	WHERE U.user_id = :uid
            ), lib_halls AS (
            	SELECT hall_id FROM "public.Halls" H
            	INNER JOIN uid_lib
            	ON NOT H.library_id = uid_lib.library_id
            ), examples AS (
            	SELECT stored_id FROM "public.IssueJournal" IJ
            	INNER JOIN uid_lib
            	ON IJ.user_id = uid_lib.user_id
            	WHERE IJ.date_issue >= :start_date AND IJ.date_issue <= :end_date
            ), books AS (
            	SELECT book_id, hall_id FROM examples
            	INNER JOIN "public.StorageInfo" SI
            	ON SI.stored_id = examples.stored_id
            )

            SELECT book_id FROM books
            INNER JOIN lib_halls
            ON books.hall_id = lib_halls.hall_id;
            """, nativeQuery = true)
    List<Integer> findBooksByUserIdAndPeriodNotFromRegLib(
            @Param("uid") Integer id,
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);

    // query 7
    @Query(value = """           
            WITH examples AS (
            	SELECT stored_id, book_id FROM "public.StorageInfo" SI
            	INNER JOIN "public.Halls" H
            	ON H.hall_id = SI.hall_id
            	WHERE H.library_id = :libId AND H.hall_id = :hallId AND bookcase = :bookcase AND shelf = :shelf
            ), issued AS (
                SELECT DISTINCT book_id FROM examples e
                INNER JOIN "public.IssueJournal" IJ
                ON IJ.stored_id = e.stored_id
                WHERE IJ.date_return IS NULL
            )
            
            SELECT * FROM "public.Books" B
            INNER JOIN issued
            ON B.book_id = issued.book_id
            """, nativeQuery = true)
    List<BookEntity> findBooksByPlace(
            @Param("libId") Integer libId,
            @Param("hallId") Integer hallId,
            @Param("bookcase") Integer bookcase,
            @Param("shelf") Integer shelf);

    // query 11 (for receipt)
    @Query(value = """           
            SELECT DISTINCT B.book_id FROM "public.StorageInfo" SI
            INNER JOIN "public.Books" B
            ON B.book_id = SI.book_id
            WHERE :start_date <= date_receipt AND date_receipt <= :end_date ;
            """, nativeQuery = true)
    List<Integer> findBooksReceiptDuringPeriod(
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);

    // query 11 (for dispose)
    @Query(value = """           
            SELECT DISTINCT B.book_id FROM "public.StorageInfo" SI
            INNER JOIN "public.Books" B
            ON B.book_id = SI.book_id
            WHERE date_dispose IS NOT NULL AND :start_date <= date_dispose AND date_dispose <= :end_date ;
            """, nativeQuery = true)
    List<Integer> findBooksDisposeDuringPeriod(
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);
}
