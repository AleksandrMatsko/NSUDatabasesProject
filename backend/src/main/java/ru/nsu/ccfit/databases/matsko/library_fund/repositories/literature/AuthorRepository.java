package ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;

@Repository
public interface AuthorRepository extends JpaRepository<AuthorEntity, Integer> {

    @Query(value = """
            INSERT INTO "public.Authors" (last_name, first_name, patronymic)
            VALUES ( :lastName , :firstName , :patronymic ) RETURNING author_id;
            """, nativeQuery = true)
    Integer insertAuthor(
            @Param("lastName") String lastName,
            @Param("firstName") String firstName,
            @Param("patronymic") String patronymic);
}
