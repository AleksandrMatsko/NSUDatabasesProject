package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibrarianRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class LibrarianService {
    private static final Logger logger = Logger.getLogger(LibrarianService.class.getName());

    @Autowired
    private LibrarianRepository librarianRepository;

    public List<LibrarianEntity> getAll() {
        logger.info(() -> "requesting all Librarians");
        List<LibrarianEntity> list = new ArrayList<>(librarianRepository.findAll());
        logger.info(() -> "got " + list.size() + " Librarians");
        return list;
    }
}
