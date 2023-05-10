package ru.nsu.ccfit.databases.matsko.library_fund.repositories;

import org.springframework.data.repository.CrudRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.BookEntity;

public interface BookRepository extends CrudRepository<BookEntity, Integer> {

}
