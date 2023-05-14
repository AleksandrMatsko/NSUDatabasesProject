package ru.nsu.ccfit.databases.matsko.library_fund.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.BookRepository;

import java.util.ArrayList;
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
        List<BookEntity> list = new ArrayList<>();
        for (BookEntity book: bookRepository.findAll()) {
            list.add(book);
        }
        logger.info(() -> "got " + list.size() + " Books");
        return list;
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
        List<BookEntity> list = new ArrayList<>();
        for (BookEntity book: bookRepository.findAllById(ids)) {
            list.add(book);
        }
        return list;
    }
}
