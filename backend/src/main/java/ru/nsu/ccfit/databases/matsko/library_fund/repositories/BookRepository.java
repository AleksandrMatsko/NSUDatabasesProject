package ru.nsu.ccfit.databases.matsko.library_fund.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.BookEntity;

public interface BookRepository extends JpaRepository<BookEntity, Integer> {

}
