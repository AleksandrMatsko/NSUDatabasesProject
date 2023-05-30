package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories.BaseUserCategoryEntity;

@Repository
public interface BaseUserCategoryRepository extends JpaRepository<BaseUserCategoryEntity, Integer> {

    @Query(value = """
            SELECT delete_user_category_info(:tableName, :id);
            """, nativeQuery = true)
    Integer deleteInfoByIdAndTable(@Param("id") Integer id, @Param("tableName") String tableName);

}
