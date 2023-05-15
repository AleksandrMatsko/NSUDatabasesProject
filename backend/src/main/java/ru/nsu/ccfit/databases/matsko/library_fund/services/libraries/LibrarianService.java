package ru.nsu.ccfit.databases.matsko.library_fund.services.libraries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibrarianRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibrarianWithNumUsers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
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

    public List<LibrarianEntity> getByLibraryAndHall(String libraryName, Integer hallId) {
        logger.info(() -> "requesting Librarians working in library with name " + libraryName + " in hall " + hallId);
        List<Integer> list = new ArrayList<>(librarianRepository.findByLibraryAndHall(libraryName, hallId));
        logger.info(() -> "got " + list.size() + " Librarians");
        return new ArrayList<>(librarianRepository.findAllById(list));
    }

    public List<LinkedHashMap<String, Object>> getWorkReport(Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting work report from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<LibrarianWithNumUsers> list = new ArrayList<>(librarianRepository.findReports(startDate, endDate));
        logger.info(() -> "got " + list.size() + " records");
        List<LinkedHashMap<String, Object>> res = new ArrayList<>();
        for (LibrarianWithNumUsers info : list) {
            LinkedHashMap<String, Object> params = new LinkedHashMap<>();
            params.put("librn", librarianRepository.findById(info.getLibrarianId()));
            params.put("numUsers", info.getNumUsers());
            res.add(params);
        }
        return res;
    }
}
