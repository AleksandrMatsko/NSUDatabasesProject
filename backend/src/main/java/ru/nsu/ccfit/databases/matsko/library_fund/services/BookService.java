package ru.nsu.ccfit.databases.matsko.library_fund.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.BookRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class BookService {

    @Autowired
    private BookRepository bookRepository;

    public List<BookEntity> getAll() {
        List<BookEntity> list = new ArrayList<>();
        for (BookEntity book: bookRepository.findAll()) {
            list.add(book);
        }
        return list;
    }

    public BookEntity add(BookEntity book) {
        return bookRepository.save(book);
    }
}
