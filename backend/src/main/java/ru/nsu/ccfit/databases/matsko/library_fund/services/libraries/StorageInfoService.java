package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.StorageInfoRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class StorageInfoService {
    private static final Logger logger = Logger.getLogger(StorageInfoService.class.getName());

    @Autowired
    private StorageInfoRepository siRepository;

    public List<StorageInfoEntity> getAll() {
        logger.info(() -> "requesting all records in storage info");
        List<StorageInfoEntity> list = new ArrayList<>(siRepository.findAll());
        logger.info(() -> "got " + list.size() + " records");
        return list;
    }

    public List<StorageInfoEntity> getByLW(String lwName) {
        logger.info(() -> "requesting all records in storage info that contain LW " + lwName);
        List<Integer> list = new ArrayList<>(siRepository.findStoredByLW(lwName));
        logger.info(() -> "got " + list.size() + " records");
        return new ArrayList<>(siRepository.findAllById(list));
    }

    public List<StorageInfoEntity> getByAuthor(String authorName) {
        logger.info(() -> "requesting all records in storage info that contain LW of author " + authorName);
        List<Integer> list = new ArrayList<>(siRepository.findStoredByAuthor(authorName));
        logger.info(() -> "got " + list.size() + " records");
        return new ArrayList<>(siRepository.findAllById(list));
    }
}
