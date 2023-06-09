package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.HallEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibraryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.HallRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibraryRepository;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.logging.Logger;

@Service
public class LibraryService {
    private static final Logger logger = Logger.getLogger(LibraryService.class.getName());

    @Autowired
    private LibraryRepository libRepository;

    @Autowired
    private HallRepository hallRepository;

    public List<LibraryEntity> getAll() {
        logger.info(() -> "requesting all libraries");
        List<LibraryEntity> list = new ArrayList<>(libRepository.findAll());
        logger.info(() -> "got " + list.size() + " libraries");
        return list;
    }

    @Transactional
    public LibraryEntity add(String name, String district, String street, String building, Integer numHalls) {
        logger.info(() -> "adding library with name: " + name + " с числом залов: " + numHalls);
        if (numHalls <= 0) {
            throw new IllegalStateException("library must have at least one hall");
        }

        LibraryEntity libraryEntity = new LibraryEntity();
        libraryEntity.setName(name);
        libraryEntity.setDistrict(district);
        libraryEntity.setStreet(street);
        libraryEntity.setBuilding(building);
        libRepository.save(libraryEntity);

        HashSet<HallEntity> hallEntities = new HashSet<>();
        for (int i = 0; i < numHalls; i++) {
            HallEntity hallEntity = new HallEntity();
            hallEntity.setLibrary(libraryEntity);
            hallEntities.add(hallEntity);
            hallRepository.save(hallEntity);
        }
        libraryEntity.setHalls(hallEntities);
        return libRepository.save(libraryEntity);
    }

    @Transactional
    public LibraryEntity update(LibraryEntity library) {
        if (libRepository.existsById(library.getLibraryId())) {
            return libRepository.save(library);
        }
        throw new IllegalStateException("no library with id = " + library.getLibraryId() + " to update");
    }
}
