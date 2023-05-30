package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.BookRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.LWRepository;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;

@Service
public class BookService {
    private final String DATE_TEMPLATE = "yyyy-MM-dd";
    private static final Logger logger = Logger.getLogger(BookService.class.getName());

    @Autowired
    private LWRepository lwRepository;

    @Autowired
    private BookRepository bookRepository;

    public List<BookEntity> getAll() {
        logger.info(() -> "requesting all Books");
        List<BookEntity> list = new ArrayList<>(bookRepository.findAll());
        logger.info(() -> "got " + list.size() + " Books");
        return list;
    }

    public List<BookEntity> getByUserIdAndPeriodFromRegLib(String lastNameTmp, Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_TEMPLATE);
        logger.info(() -> "requesting books borrowed by user " + lastNameTmp + " from " +
                format.format(startDate) + " to " + format.format(endDate) + " from library where he was registered");
        List<Integer> list = new ArrayList<>(bookRepository.findBooksByUserIdAndPeriodFromRegLib(
                lastNameTmp, startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));

    }

    public List<BookEntity> getByUserIdAndPeriodNotFromRegLib(String lastNameTmp, Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_TEMPLATE);
        logger.info(() -> "requesting books borrowed by user " + lastNameTmp + " from " +
                format.format(startDate) + " to " + format.format(endDate) +
                " from all libraries except where he was registered");
        List<Integer> list = new ArrayList<>(bookRepository.findBooksByUserIdAndPeriodNotFromRegLib(
                lastNameTmp, startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    public List<BookEntity> getByPlace(String libName, Integer hallId, Integer bookcase, Integer shelf) {
        logger.info(() -> "requesting books from lib " + libName + " in hall with id = " + hallId +
                " in bookcase = " + bookcase + " on shelf " + shelf);
        List<Integer> list = new ArrayList<>(bookRepository.findBooksByPlace(libName, hallId, bookcase, shelf));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    public List<BookEntity> getReceiptDuringPeriod(Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_TEMPLATE);
        logger.info(() -> "requesting books receipt from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<Integer> list = new ArrayList<>(bookRepository.findBooksReceiptDuringPeriod(startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    public List<BookEntity> getDisposeDuringPeriod(Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_TEMPLATE);
        logger.info(() -> "requesting books dispose from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<Integer> list = new ArrayList<>(bookRepository.findBooksDisposeDuringPeriod(startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    @Transactional
    public BookEntity add(String bookName, List<Integer> lwIds) {
        logger.info(() -> "inserting new book with name " + bookName);
        List<LiteraryWorkEntity> lws = lwRepository.findAllById(lwIds);
        if (lws.isEmpty()) {
            throw new IllegalStateException("book must contain at least one literary work");
        }
        BookEntity bookEntity = new BookEntity();
        bookEntity.setName(bookName);
        bookEntity.setLiteraryWorks(new HashSet<>(lws));
        return bookRepository.save(bookEntity);
    }

    public BookEntity getById(Integer id) {
        logger.info(() -> "getting book with id = " + id);
        Optional<BookEntity> res = bookRepository.findById(id);
        return res.orElse( null);
    }


    @Transactional
    public BookEntity update(BookEntity newBook) {
        if (bookRepository.existsById(newBook.getBookId())) {
            return bookRepository.save(newBook);
        }
        throw new IllegalStateException("book with id = " + newBook.getBookId() + " doesn't exist");
    }

    public List<BookEntity> getAllByIds(List<Integer> ids) {
        return new ArrayList<>(bookRepository.findAllById(ids));
    }

    @Transactional
    public void delete(Integer id) {
        logger.info(() -> "deleting book with id: " + id);
        bookRepository.deleteBookById(id);
    }

}
