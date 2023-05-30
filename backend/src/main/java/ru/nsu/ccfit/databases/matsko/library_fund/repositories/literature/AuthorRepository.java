package ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;

@Repository
public interface AuthorRepository extends JpaRepository<AuthorEntity, Integer> {

    @Query(value = """
            DELETE FROM public."public.Authors"
            	WHERE author_id = :id RETURNING author_id;
            """, nativeQuery = true)
    Integer deleteAuthorById(@Param("id") Integer id);
}
