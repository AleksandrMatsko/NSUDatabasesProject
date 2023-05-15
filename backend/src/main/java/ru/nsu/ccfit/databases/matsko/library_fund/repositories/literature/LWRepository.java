package ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;

import java.util.List;

@Repository
public interface LWRepository extends JpaRepository<LiteraryWorkEntity, Integer> {

    // query 16
    @Query(value = """
            WITH issue_cnts AS (
            	SELECT stored_id, COUNT(stored_id) AS s_cnt FROM "public.IssueJournal"
            	GROUP BY stored_id
            ), book_cnts AS (
            	SELECT book_id, SUM(s_cnt) as bk_cnt FROM issue_cnts
            	INNER JOIN "public.StorageInfo" SI
            	ON SI.stored_id = issue_cnts.stored_id
            	GROUP BY book_id
            ), lw_cnts AS (
            	SELECT lw_id, SUM(bk_cnt) AS cnt FROM "public.WorksInBook" WIB
            	INNER JOIN book_cnts
            	ON WIB.book_id = book_cnts.book_id
            	GROUP BY lw_id
            )
                        
            SELECT LW.lw_id as lwID, lw_cnts.cnt AS count FROM lw_cnts
            RIGHT JOIN "public.LiteraryWorks" LW
            ON LW.lw_id = lw_cnts.lw_id
            ORDER BY lw_cnts.cnt DESC NULLS LAST, "name" ASC
            LIMIT :lim
            """, nativeQuery = true)
    List<LWWithCount> findPopularLW(@Param("lim") Integer limit);
}
