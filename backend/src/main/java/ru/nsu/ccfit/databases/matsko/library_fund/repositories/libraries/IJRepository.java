package ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;

@Repository
public interface IJRepository extends JpaRepository<IssueJournalEntity, Integer> {

    @Query(value = """
            DELETE FROM public."public.IssueJournal"
            	WHERE issue_id = :id RETURNING issue_id;
            """, nativeQuery = true)
    Integer deleteIssueById(@Param("id") Integer id);

}
