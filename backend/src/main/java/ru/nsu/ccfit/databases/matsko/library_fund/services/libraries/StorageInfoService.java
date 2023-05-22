package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.HallEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.HallRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.StorageInfoRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.BookRepository;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

@Service
public class StorageInfoService {
    private static final Logger logger = Logger.getLogger(StorageInfoService.class.getName());

    @Autowired
    private StorageInfoRepository siRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private HallRepository hallRepository;

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

    @Transactional
    public StorageInfoEntity add(Integer bookId, Integer hallId, Integer bookcase, Integer shelf,
                                 Boolean availableIssue, Integer durationIssue, Date dateReceipt, Date dateDispose) {
        logger.info(() -> "adding new record in storage info");
        BookEntity book = bookRepository.findById(bookId).orElseThrow(
                () -> new IllegalStateException("stored must have relation to existing book"));
        HallEntity hall = hallRepository.findById(hallId).orElseThrow(
                () -> new IllegalStateException("example must be stored in existing hall"));
        StorageInfoEntity storageInfoEntity = new StorageInfoEntity();
        storageInfoEntity.setBook(book);
        storageInfoEntity.setHall(hall);
        storageInfoEntity.setBookcase(bookcase);
        storageInfoEntity.setShelf(shelf);
        storageInfoEntity.setAvailableIssue(availableIssue);
        storageInfoEntity.setDurationIssue(durationIssue);
        storageInfoEntity.setDateReceipt(dateReceipt);
        storageInfoEntity.setDateDispose(dateDispose);
        return siRepository.save(storageInfoEntity);
    }

    @Transactional
    public StorageInfoEntity update(StorageInfoEntity storageInfoEntity) {
        if (siRepository.existsById(storageInfoEntity.getStoredId())) {
            return siRepository.save(storageInfoEntity);
        }
        throw new IllegalStateException("no stored with id = " + storageInfoEntity.getStoredId() + " to update");
    }
}
