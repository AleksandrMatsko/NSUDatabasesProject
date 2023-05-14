package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.IJRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class IJService {
    private static final Logger logger = Logger.getLogger(IJService.class.getName());

    @Autowired
    private IJRepository ijRepository;

    public List<IssueJournalEntity> getAll() {
        logger.info(() -> "requesting all records in issue journal");
        List<IssueJournalEntity> list = new ArrayList<>(ijRepository.findAll());
        logger.info(() -> "got " + list.size() + " records");
        return list;
    }
}
