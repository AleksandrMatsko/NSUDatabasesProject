package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.RegistrationJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.RJRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class RJService {
    private static final Logger logger = Logger.getLogger(RJService.class.getName());

    @Autowired
    private RJRepository rjRepository;

    public List<RegistrationJournalEntity> getAll() {
        logger.info(() -> "requesting all records in registration journal");
        List<RegistrationJournalEntity> list = new ArrayList<>(rjRepository.findAll());
        logger.info(() -> "got " + list.size() + " records");
        return list;
    }
}
