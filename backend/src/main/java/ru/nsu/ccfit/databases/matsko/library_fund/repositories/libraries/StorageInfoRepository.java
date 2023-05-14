package ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;

@Repository
public interface StorageInfoRepository extends JpaRepository<StorageInfoEntity, Integer> {
}
