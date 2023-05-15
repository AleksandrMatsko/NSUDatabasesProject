package ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;

import java.util.List;

@Repository
public interface StorageInfoRepository extends JpaRepository<StorageInfoEntity, Integer> {

    // query 14
    @Query(value = """
            WITH books AS (
            	SELECT book_id FROM "public.LiteraryWorks" LW
            	INNER JOIN "public.WorksInBook" WB
            	ON LW.lw_id = WB.lw_id
            	WHERE LW."name" ILIKE '%' || :lwName || '%'
            )
                                    
            SELECT stored_id FROM "public.StorageInfo" SI
            INNER JOIN books
            ON SI.book_id = books.book_id;
            """, nativeQuery = true)
    List<Integer> findStoredByLW(@Param("lwName") String lwName);

    // query 15
    @Query(value = """
            WITH lworks AS (
            	SELECT lw_id FROM "public.Authors" AU
            	INNER JOIN "public.AuthorsWorks" AW
            	ON AU.author_id = AW.author_id
            	WHERE AU.last_name ILIKE '%' || :authorName || '%'
            ), books AS (
            	SELECT DISTINCT book_id FROM lworks
            	INNER JOIN "public.WorksInBook" WB
            	ON lworks.lw_id = WB.lw_id
            )
                        
            SELECT stored_id FROM "public.StorageInfo" SI
            INNER JOIN books
            ON SI.book_id = books.book_id
            """, nativeQuery = true)
    List<Integer> findStoredByAuthor(@Param("authorName") String authorName);
}
