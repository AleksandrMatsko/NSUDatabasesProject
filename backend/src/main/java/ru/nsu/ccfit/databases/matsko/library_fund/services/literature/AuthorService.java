package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.AuthorRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class AuthorService {
    private static final Logger logger = Logger.getLogger(AuthorService.class.getName());

    @Autowired
    private AuthorRepository authorRepository;

    public List<AuthorEntity> getAll() {
        logger.info(() -> "requesting all authors");
        List<AuthorEntity> list = new ArrayList<>(authorRepository.findAll());
        logger.info(() -> "got " + list.size() + " authors");
        return list;
    }
}
