package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserCategoryEntity;

@Repository
public interface UserCategoryRepository extends JpaRepository<UserCategoryEntity, Integer> {

    @Query(value = """
            SELECT * FROM "public.UserCategories"
            WHERE category_name = :categoryName ;
            """, nativeQuery = true)
    UserCategoryEntity getCategoryByName(@Param("categoryName") String categoryName);
}
