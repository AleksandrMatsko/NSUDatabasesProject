package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.BookRepository;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@Service
public class BookService {
    private static final Logger logger = Logger.getLogger(BookService.class.getName());

    @Autowired
    private BookRepository bookRepository;

    public List<BookEntity> getAll() {
        logger.info(() -> "requesting all Books");
        List<BookEntity> list = new ArrayList<>(bookRepository.findAll());
        logger.info(() -> "got " + list.size() + " Books");
        return list;
    }

    public List<BookEntity> getByUserIdAndPeriodFromRegLib(Integer id, Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting books borrowed by user with id " + id + " from " +
                format.format(startDate) + " to " + format.format(endDate) + " from library where he was registered");
        List<Integer> list = new ArrayList<>(bookRepository.findBooksByUserIdAndPeriodFromRegLib(id, startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));

    }

    public List<BookEntity> getByUserIdAndPeriodNotFromRegLib(Integer id, Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting books borrowed by user with id " + id + " from " +
                format.format(startDate) + " to " + format.format(endDate) +
                " from all libraries except where he was registered");
        List<Integer> list = new ArrayList<>(bookRepository.findBooksByUserIdAndPeriodNotFromRegLib(id, startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    public List<BookEntity> getByPlace(Integer libId, Integer hallId, Integer bookcase, Integer shelf) {
        logger.info(() -> "requesting books from lib with id = " + libId + " in hall with id = " + hallId +
                " in bookcase = " + bookcase + " on shelf " + shelf);
        List<BookEntity> list = new ArrayList<>(bookRepository.findAll());
        logger.info(() -> "got " + list.size() + " Books");
        return list;
    }

    public List<BookEntity> getReceiptDuringPeriod(Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting books receipt from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<Integer> list = new ArrayList<>(bookRepository.findBooksReceiptDuringPeriod(startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    public List<BookEntity> getDisposeDuringPeriod(Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting books dispose from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<Integer> list = new ArrayList<>(bookRepository.findBooksDisposeDuringPeriod(startDate, endDate));
        logger.info(() -> "got " + list.size() + " Books");
        return new ArrayList<>(bookRepository.findAllById(list));
    }

    public BookEntity add(BookEntity book) {
        return bookRepository.save(book);
    }

    public BookEntity getById(Integer id) {
        Optional<BookEntity> res = bookRepository.findById(id);
        return res.orElse( null);
    }


    public BookEntity updateById(BookEntity newBook) {
        Optional<BookEntity> prevBook = bookRepository.findById(newBook.getBookId());
        if (prevBook.isPresent()) {
            return bookRepository.save(newBook);
        }
        return null;
    }

    public List<BookEntity> getAllByIds(List<Integer> ids) {
        return new ArrayList<>(bookRepository.findAllById(ids));
    }
}
