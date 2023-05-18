package ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LWCategoryEntity;

@Repository
public interface LWCategoryRepository extends JpaRepository<LWCategoryEntity, Integer> {

    @Query(value = """
            SELECT * FROM "public.LWCategories"
            WHERE category_name = :categoryName ;
            """, nativeQuery = true)
    LWCategoryEntity getCategoryByName(@Param("categoryName") String categoryName);
}
