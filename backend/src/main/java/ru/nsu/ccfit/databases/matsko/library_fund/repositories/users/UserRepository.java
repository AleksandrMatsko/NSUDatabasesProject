package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

import java.util.Date;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {

    // query 2
    @Query(value = """
            WITH in_books AS (
            	SELECT book_id FROM "public.LiteraryWorks" LW
            	INNER JOIN "public.WorksInBook" WB
            	ON LW.lw_id = WB.lw_id
            	WHERE LW.name ILIKE '%' || :lwtmp || '%'
            ), examples AS (
            	SELECT stored_id FROM "public.StorageInfo" SI
            	INNER JOIN in_books
            	ON SI.book_id = in_books.book_id
            )
                                    
            SELECT user_id as uid FROM "public.IssueJournal" IJ
            INNER JOIN examples
            ON IJ.stored_id = examples.stored_id
            WHERE IJ.date_return IS NULL
            """, nativeQuery = true)
    List<Integer> findUsersWithLW(@Param("lwtmp") String lwTemplate);

    // query 3
    @Query(value = """
            WITH examples AS (
            	SELECT stored_id FROM "public.StorageInfo" SI
            	INNER JOIN "public.Books" B
            	ON SI.book_id = B.book_id
            	WHERE B.name ILIKE '%' || :booktmp || '%'
            )
            
            SELECT user_id FROM "public.IssueJournal" IJ
            INNER JOIN examples
            ON IJ.stored_id = examples.stored_id
            WHERE IJ.date_return IS NULL;
            """, nativeQuery = true)
    List<Integer> findUsersWithBooks(@Param("booktmp") String bookTemplate);

    // query 4
    @Query(value = """
            WITH in_books AS (
            	SELECT book_id FROM "public.LiteraryWorks" LW
            	INNER JOIN "public.WorksInBook" WB
            	ON LW.lw_id = WB.lw_id
            	WHERE LW.name ILIKE '%' || :lwtmp || '%'
            ), examples AS (
            	SELECT stored_id, SI.book_id FROM "public.StorageInfo" SI
            	INNER JOIN in_books
            	ON SI.book_id = in_books.book_id
            )
            
            SELECT IJ.user_id AS userId, examples.book_id AS bookId FROM "public.IssueJournal" IJ
            INNER JOIN examples
            ON IJ.stored_id = examples.stored_id
            WHERE IJ.date_issue >= :start_date AND IJ.date_issue <= :end_date
            """, nativeQuery = true)
    List<UserBookPair> findUsersAndBookNameByLWDuringPeriod(
            @Param("lwtmp") String bookTemplate,
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);

    // query 8
    @Query(value = """           
            WITH librn AS (
            	SELECT librarian_id FROM "public.Librarians" L
            	WHERE last_name ILIKE '%' || :librnLastName || '%'
            ), users AS (
            	SELECT DISTINCT user_id FROM "public.IssueJournal" IJ, librn
            	WHERE ((:start_date < date_issue AND date_issue < :end_date) OR
            		(date_return IS NOT NULL AND :start_date < date_return AND date_return < :end_date)) AND
            		(IJ.issued_by_lbrn = librn.librarian_id OR IJ.accepted_by_lbrn = librn.librarian_id)
            	UNION SELECT user_id FROM "public.RegistrationJournal" RJ, librn
            	WHERE :start_date < registration_date AND registration_date < :end_date AND
            		RJ.librarian_id = librn.librarian_id
            )
                        
            SELECT U.user_id FROM "public.Users" U
            INNER JOIN users
            ON U.user_id = users.user_id
            """, nativeQuery = true)
    List<Integer> findUsersByLibrnIdAndPeriod(
            @Param("librnLastName") String librnLastName,
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);

    // query 10
    @Query(value = """
            WITH durations AS (
            	SELECT user_id, date_issue + duration_issue AS exp_date, date_return FROM "public.StorageInfo" SI
            	INNER JOIN "public.IssueJournal" IJ
            	ON IJ.stored_id = SI.stored_id
            	WHERE available_issue
            )
            
            SELECT DISTINCT user_id FROM durations
            WHERE (date_return IS NOT NULL AND exp_date < date_return) OR (date_return IS NULL AND exp_date < NOW())
            """, nativeQuery = true)
    List<Integer> findUsersWithOverdueBooks();

    // query 13
    @Query(value = """           
            WITH users AS (
                SELECT DISTINCT user_id FROM "public.IssueJournal" IJ
                WHERE (date_issue <= :end_date AND date_issue >= :start_date) OR
            	    (date_return IS NOT NULL AND date_return <= :end_date AND date_return >= :start_date)	
                UNION SELECT DISTINCT user_id FROM "public.RegistrationJournal" RJ
                WHERE registration_date <= :end_date AND registration_date >= :start_date
            )
            
            SELECT U.user_id FROM "public.Users" U
            WHERE U.user_id NOT IN(SELECT users.user_id FROM users)
            """, nativeQuery = true)
    List<Integer> findUsersNotVisitDuringPeriod(
            @Param("start_date") Date startDate,
            @Param("end_date") Date endDate);

    @Query(value = """
            DELETE FROM public."public.Users"
            	WHERE user_id = :id RETURNING user_id ;
            """, nativeQuery = true)
    Integer deleteUserById(@Param("id") Integer id);
}
