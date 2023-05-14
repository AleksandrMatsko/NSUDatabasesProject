package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
}
