package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibraryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibraryRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class LibraryService {
    private static final Logger logger = Logger.getLogger(LibraryService.class.getName());

    @Autowired
    private LibraryRepository libRepository;

    public List<LibraryEntity> getAll() {
        logger.info(() -> "requesting all libraries");
        List<LibraryEntity> list = new ArrayList<>(libRepository.findAll());
        logger.info(() -> "got " + list.size() + " libraries");
        return list;
    }
}
