package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.IJRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibrarianRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.StorageInfoRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserRepository;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

@Service
public class IJService {
    private static final Logger logger = Logger.getLogger(IJService.class.getName());

    @Autowired
    private IJRepository ijRepository;

    @Autowired
    private StorageInfoRepository storageInfoRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LibrarianRepository librarianRepository;

    public List<IssueJournalEntity> getAll() {
        logger.info(() -> "requesting all records in issue journal");
        List<IssueJournalEntity> list = new ArrayList<>(ijRepository.findAll());
        logger.info(() -> "got " + list.size() + " records");
        return list;
    }

    @Transactional
    public IssueJournalEntity add(Integer storedId, Integer userId, Date dateIssue, Date dateReturn, Integer issuedBy,
                                  Integer acceptedBy) {
        StorageInfoEntity storageInfoEntity = storageInfoRepository.findById(storedId).orElseThrow(
                () -> new IllegalStateException("stored required to issue"));
        UserEntity userEntity = userRepository.findById(userId).orElseThrow(
                () -> new IllegalStateException("user required to issue"));
        LibrarianEntity issueLibrarian = librarianRepository.findById(issuedBy).orElseThrow(
                () -> new IllegalStateException("librarian required to issue"));
        IssueJournalEntity issueJournalEntity = new IssueJournalEntity();
        issueJournalEntity.setUser(userEntity);
        issueJournalEntity.setStored(storageInfoEntity);
        issueJournalEntity.setDateIssue(dateIssue);
        issueJournalEntity.setIssuedBy(issueLibrarian);
        if (dateReturn != null && acceptedBy != null) {
            LibrarianEntity acceptedLibrarian = librarianRepository.findById(acceptedBy).orElseThrow(
                    () -> new IllegalStateException("librarian required to accept"));
            issueJournalEntity.setDateReturn(dateReturn);
            issueJournalEntity.setAcceptedBy(acceptedLibrarian);
        }
        else if ((dateReturn != null && acceptedBy == null) || (dateReturn == null && acceptedBy != null)) {
            throw new IllegalStateException("not enough info about accepting book");
        }
        return ijRepository.save(issueJournalEntity);
    }

    @Transactional
    public IssueJournalEntity update(IssueJournalEntity ij) {
        logger.info(() -> "updating ij record with id = " + ij.getIssueId());
        if (ijRepository.existsById(ij.getIssueId())) {
            return ijRepository.save(ij);
        }
        throw new IllegalStateException("issue journal record with id = " + ij.getIssueId() + " not found to update");
    }
}
