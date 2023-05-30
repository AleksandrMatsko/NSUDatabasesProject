package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import jakarta.transaction.Transactional;
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

    @Transactional
    public AuthorEntity addAuthor(String lastName, String firstName, String patronymic) {
        logger.info(() -> "inserting new author");
        AuthorEntity authorEntity = new AuthorEntity();
        authorEntity.setLastName(lastName);
        authorEntity.setFirstName(firstName);
        authorEntity.setPatronymic(patronymic);
        return authorRepository.save(authorEntity);
    }

    @Transactional
    public AuthorEntity update(AuthorEntity authorEntity) {
        logger.info(() -> "updating author with id = " + authorEntity.getAuthorId());
        if (authorRepository.existsById(authorEntity.getAuthorId())) {
            return authorRepository.save(authorEntity);
        }
        throw new IllegalStateException("author with id " + authorEntity.getAuthorId() + " not found");
    }

    @Transactional
    public Integer delete(Integer id) {
        logger.info(() -> "deleting author with id: " + id);
        return authorRepository.deleteAuthorById(id);
    }

}
