package ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;

@Repository
public interface IJRepository extends JpaRepository<IssueJournalEntity, Integer> {
}
