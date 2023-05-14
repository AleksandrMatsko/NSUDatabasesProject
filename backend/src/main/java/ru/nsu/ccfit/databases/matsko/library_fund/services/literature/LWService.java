package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.LWRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class LWService {
    private static final Logger logger = Logger.getLogger(LWService.class.getName());

    @Autowired
    private LWRepository lwRepository;

    public List<LiteraryWorkEntity> getAll() {
        logger.info(() -> "requesting all literary works");
        List<LiteraryWorkEntity> list = new ArrayList<>(lwRepository.findAll());
        logger.info(() -> "got " + list.size() + " literary works");
        return list;
    }
}
