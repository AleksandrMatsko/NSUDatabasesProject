package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import jakarta.persistence.EntityResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

import java.util.Date;
import java.util.List;
import java.util.Map;

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
}
