package ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories.BaseLWCategoryEntity;

@Repository
public interface BaseLWCategoryRepository extends JpaRepository<BaseLWCategoryEntity, Integer> {
}
